class Contact < ActiveRecord::Base

	validates_presence_of :email
	validates_uniqueness_of :email
	has_and_belongs_to_many :organizational_units
	belongs_to :person

	before_save :associate_person
	
	private
	
		def associate_person
		  if !self.email.blank?
		    pers = Person.find_by_email(self.email) 
			  self.person = pers
			  self.first_name = pers.first_name if pers and self.first_name.blank?
			  self.last_name  = pers.last_name  if pers and self.last_name.blank?
		  end
		end

end
