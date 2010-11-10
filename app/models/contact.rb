class Contact < ActiveRecord::Base

	validates_presence_of :email
	validates_uniqueness_of :email
	has_and_belongs_to_many :organizational_units
	belongs_to :person

	before_save :associate_person
	
	def to_s
	 "#{self.first_name} #{self.last_name} #{self.email}".strip
	end
	
	def self.import_data(file, org_unit)
	  FasterCSV.parse(file, :headers => true, :header_converters => :symbol) do |row|
      next if row.header_row?
      next if row[:email_address].blank?
      process_import_row(row, org_unit)
    end
	end
	
	private
	
	  def self.process_import_row(row, org_unit)
	    contact = Contact.find_or_create_by_email(row[:email_address])
      [:first_name, :last_name, :company_name].each { |attribute| contact.send("#{attribute}=", row[attribute]) unless row[attribute].blank? }
      contact.organizational_units << org_unit if !org_unit.nil? and !contact.organizational_units.include?(org_unit)
      contact.save!
	  end
	
		def associate_person
		  if !self.email.blank?
		    pers = Person.find_by_email(self.email) 
			  self.person = pers
			  self.first_name = pers.first_name if pers and self.first_name.blank?
			  self.last_name  = pers.last_name  if pers and self.last_name.blank?
		  end
		end

end
