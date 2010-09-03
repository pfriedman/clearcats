# == Schema Information
# Schema version: 20100903173011
#
# Table name: people
#
#  id                                            :integer         not null, primary key
#  first_name                                    :string(255)
#  middle_name                                   :string(255)
#  last_name                                     :string(255)
#  netid                                         :string(255)
#  email                                         :string(255)
#  department_affiliation                        :string(255)
#  school_affiliation                            :string(255)
#  last_four_of_ssn                              :string(255)
#  phone                                         :string(255)
#  era_commons_username                          :string(255)
#  employeeid                                    :string(255)
#  department_id                                 :integer
#  degree_type_one_id                            :integer
#  degree_type_two_id                            :integer
#  specialty_id                                  :integer
#  country_id                                    :integer
#  ethnic_type_id                                :integer
#  race_type_id                                  :integer
#  disadvantaged_background                      :boolean
#  created_at                                    :datetime
#  updated_at                                    :datetime
#  human_subject_protection_training_institution :string(255)
#  human_subject_protection_training_date        :date
#  service_rendered                              :boolean
#  training_type                                 :string(255)
#  trainee_status                                :string(255)
#  has_disability                                :boolean
#  gender                                        :string(255)
#  title                                         :string(255)
#  fax                                           :string(255)
#  address                                       :string(255)
#  edited                                        :boolean
#  imported                                      :boolean
#

# TurboCATS                 ClearCATS
# commons_username          era_commons_username
# middle_initial            middle_name
# area_of_expertise_code    specialty.name
# degree_1                  degree_type_one.name
# degree_2                  degree_type_two.name
# ethnic_category           ethnic_type.name
# racial_category           race_type.name

# Same
# first_name
# last_name
# disadvantaged_background


# ClearCATS only
#  netid                                         :string(255)
#  email                                         :string(255)
#  department_affiliation                        :string(255)
#  school_affiliation                            :string(255)
#  last_four_of_ssn                              :string(255)
#  phone                                         :string(255)
#  human_subject_protection_training_institution :string(255)
#  human_subject_protection_training_date        :date

# TurboCATS only

#  gender                   :string(255)
#  mentor_commons_username  :string(255)
#  invalid                  :boolean
#  validation_messages      :text
#  reporting_year           :string(255)
#  training_type            :string(255)
#  appointed                :boolean
#  accepted                 :boolean
#  applied                  :boolean
#  interviewed              :boolean
#  end_date                 :date
#  date_of_appointment      :date
#  has_disability           :boolean


require 'comma'
class Person < ActiveRecord::Base
  include VersionExportable
  has_paper_trail
  
  SCHOLAR      = "scholar"
  OTHER_CAREER = "other_career_development"
  TRAINEE      = "trainee"
  APPLICANT    = "applicant"
  APPOINTED    = "appointed"
  MALE         = "Male"
  FEMALE       = "Female"
  NOT_REPORTED = "Not_Reported"
  
  TRAINING_TYPES   = [TRAINEE, SCHOLAR, OTHER_CAREER]
  TRAINEE_STATUSES = [APPLICANT, APPOINTED]
  GENDERS          = [NOT_REPORTED, MALE, FEMALE]
  
  belongs_to :department

  has_many :services
  has_many :awards
  has_many :publications
  has_many :approvals
  has_and_belongs_to_many :institution_positions
  has_and_belongs_to_many :organizational_units
    
  belongs_to :country
  belongs_to :degree_type_one
  belongs_to :degree_type_two
  belongs_to :specialty
  belongs_to :ethnic_type
  belongs_to :race_type

  validates_length_of :last_four_of_ssn, :is => 4, :if => proc { |obj| !obj.last_four_of_ssn.blank? }
  
  validates_inclusion_of :training_type,  :in => TRAINING_TYPES,   :if => proc { |obj| !obj.training_type.blank? }
  validates_inclusion_of :trainee_status, :in => TRAINEE_STATUSES, :if => proc { |obj| !obj.trainee_status.blank? }
  validates_inclusion_of :gender,         :in => GENDERS,          :if => proc { |obj| !obj.gender.blank? }
  
  # Person record must have either netid or era_commons_username
  validates_presence_of :netid,                :if => proc { |obj| obj.era_commons_username.blank? and !obj.imported? }
  validates_presence_of :era_commons_username, :if => proc { |obj| obj.netid.blank? and !obj.imported? }
  
  validates_presence_of :last_name,  :if => proc { |obj| !obj.imported? }
  validates_presence_of :first_name, :if => proc { |obj| !obj.imported? }
  validates_presence_of :email,      :if => proc { |obj| !obj.imported? }
  
  accepts_nested_attributes_for :awards,       :allow_destroy => true
  accepts_nested_attributes_for :publications, :allow_destroy => true
  accepts_nested_attributes_for :approvals,    :allow_destroy => true
  
  named_scope :awards_phs_organization_id_equals,     lambda { |id|  {:joins => :awards, :conditions => ["awards.organization_id  = :id and awards.organization_type = 'PhsOrganization'",    {:id => id} ]} }
  named_scope :awards_activity_code_id_equals,        lambda { |id|  {:joins => :awards, :conditions => ["awards.activity_code_id = :id",       {:id => id} ]} }
  named_scope :awards_non_phs_organization_id_equals, lambda { |id|  {:joins => :awards, :conditions => ["awards.organization_id  = :id and awards.organization_type = 'NonPhsOrganization'", {:id => id} ]} }
  
  named_scope :organizational_units_organizational_unit_id_equals, lambda { |id| {:joins => :organizational_units, :conditions => ["organizational_units.id = :id", {:id => id} ]} }
  
  named_scope :all_investigators, :conditions => "training_type IS NULL AND trainee_status IS NULL"
  named_scope :all_trainees,      :conditions => ["training_type IS NOT NULL AND trainee_status IS NOT NULL"]
  
  named_scope :scholars,      :conditions => { :training_type => SCHOLAR }
  named_scope :other_careers, :conditions => { :training_type => OTHER_CAREER }
  named_scope :trainees,      :conditions => { :training_type => TRAINEE }

  # attributes from faculty_web_service that are not persisted
  attr_accessor :interests, :campus, :descriptions, :dv_abbr
  attr_accessor :basis, :category, :dept_id, :career_track, :degree, :division
  attr_accessor :joint, :rank, :employee_id, :division_id, :pmids, :centers, :secondary
  attr_accessor :demographics, :certifications, :field_of_study
  
  def employee_id=(emplid)
    self.employeeid = emplid
  end
  
  def to_s
    return "#{first_name} #{last_name}".strip
  end
  
  before_save :set_affiliations
  
  def set_affiliations
    if self.department
      self.department_affiliation = self.department.entity_name unless self.department.entity_name.blank?
      self.school_affiliation     = self.department.school      unless self.department.school.blank?
    end
  end
  
  def awards_for_organization(org)
    results = self.awards.select {|a| a.organization == org}
    results
  end


  ###
  #    For CTSA reporting
  ###
  
  def middle_initial=(mi)
    self.middle_name = mi
  end
  
  def commons_username
    self.era_commons_username.to_s
  end
  
  def area_of_expertise_code
    self.specialty.blank? ? "" : self.specialty.code
  end

  def degree_1
    self.degree_type_one.to_s
  end
  
  def degree_2
    self.degree_type_two.to_s    
  end
  
  def ethnic_category
    self.ethnic_type.to_s
  end
  
  def racial_category
    self.race_type.to_s
  end
  
  # TODO: determine the date_of_appointment reporting item
  def date_of_appointment
    Date.today
  end
  
  # TODO: determine the end_date reporting item
  def end_date
    Date.today
  end
  
  # TODO: determine the mentor_commons_name reporting item
  def mentor_commons_username
    ""
  end

  ###
  #    For LDAP
  ###
  
  def mail=(mail)
    self.email = mail
  end
  
  def givenname=(name)
    self.first_name = name
  end
  
  def sn=(name)
    self.last_name = name
  end
  
  def telephonenumber=(number)
    self.phone = number
  end
  
  def facsimiletelephonenumber=(number)
    self.fax = number
  end
  
  def postaladdress=(addr)
    if !addr.nil?
      parts  = addr.split('$')
      campus = case parts.last
               when /^EV|Evanston/; "Evanston";
               when /^CH|Chicago/; "Chicago";
               end
      parts.delete_at(-1) if campus
      self.address = parts.join("\n")
    end
  end
  
  def displayname=(name)
    # guess middle name - this'll be tricky if the displayname has more than three parts
    parts = name.split(/\s+/)
    self.middle_name = (parts[2] && parts[1])
  end


  ###
  #    Parsing data from CSV
  ###

  def self.import_data(file, user)
    FasterCSV.parse(file, :headers => :first_row, :write_headers=>false, :return_headers => false, :header_converters => :symbol) do |row|
      if !row[:commons_username].blank?
        pers = Person.find_or_create_by_era_commons_username(row[:commons_username])
        specialty = Specialty.find_by_code(row[:area_of_expertise])
        pers.specialty = specialty unless specialty.nil?
        [:first_name, :last_name, :middle_initial, :email].each { |attribute| pers.send("#{attribute}=", row[attribute]) unless row[attribute].blank? }
        pers.organizational_units << user.organizational_unit unless user.organizational_unit.nil?
        pers.save
      end
    end
  end

  def import_row(row)
    
  end

  ###
  #    Support for exporting to CSV
  ###
  
  comma do
    last_name
    first_name
    middle_name
    netid
    email
    phone
    employeeid
    era_commons_username
    department_affiliation
    school_affiliation
    last_four_of_ssn
    degree_type_one
    degree_type_two
    specialty
    country
    ethnic_type "Ethnic Background"
    race_type "Racial Background"
    disadvantaged_background
    human_subject_protection_training_institution
    human_subject_protection_training_date
    institution_positions :to_sentence => "Position/Title"
    services :to_sentence => "Services"
    organizational_units :to_sentence => "Organizational Units"
  end

  # # starts a Comma description block, generating 2 methods #to_comma and
  # # #to_comma_headers for this class.
  # comma do
  # 
  #   # name, description are attributes of Book with the header being reflected as
  #   # 'Name', 'Description'
  #   name
  #   description
  # 
  #   # pages is an association returning an array, :size is called on the
  #   # association results, with the header name specified as 'Pages'
  #   pages :size => 'Pages'
  # 
  #   # publisher is an association returning an object, :name is called on the
  #   # associated object, with the reflected header 'Name'
  #   publisher :name
  # 
  #   # isbn is an association returning an object, :number_10 and :number_13 are
  #   # called on the object with the specified headers 'ISBN-10' and 'ISBN-13'
  #   isbn :number_10 => 'ISBN-10', :number_13 => 'ISBN-13'
  # 
  #   # blurb is an attribute of Book, with the header being specified directly
  #   # as 'Summary'
  #   blurb 'Summary'
  # 
  # end
end
