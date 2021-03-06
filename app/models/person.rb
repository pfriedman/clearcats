# == Schema Information
# Schema version: 20101216175350
#
# Table name: people
#
#  id                                            :integer         not null, primary key
#  type                                          :string(255)
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
#  personnelid                                   :string(255)
#  address                                       :string(255)
#  city                                          :string(255)
#  state                                         :string(255)
#  edited_by_user                                :boolean
#  organizational_unit_id                        :integer
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
#  edited                                        :boolean
#  imported                                      :boolean
#  ctsa_reporting_years_mask                     :integer
#  system_administrator                          :boolean
#  created_by                                    :string(255)
#  updated_by                                    :string(255)
#  mentor_era_commons_username                   :string(255)
#  appointment_date                              :date
#  end_date                                      :date
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
require 'bcsec'
class Person < ActiveRecord::Base
  include VersionExportable
  include CtsaReportable
  
  has_paper_trail :ignore => [:ctsa_reporting_years_mask]
  
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
  
  validates_uniqueness_of :netid, :if => proc { |obj| !obj.netid.blank? }
  # validates_uniqueness_of :era_commons_username, :if => proc { |obj| !obj.era_commons_username.blank? }
  
  validates_presence_of :last_name,  :if => proc { |obj| !obj.imported? }
  validates_presence_of :first_name, :if => proc { |obj| !obj.imported? }
  # validates_presence_of :email,      :if => proc { |obj| !obj.imported? }
  
  accepts_nested_attributes_for :awards,       :allow_destroy => true
  accepts_nested_attributes_for :publications, :allow_destroy => true
  accepts_nested_attributes_for :approvals,    :allow_destroy => true
  
  named_scope :awards_phs_organization_id_equals,     lambda { |id|  {:joins => :awards, :conditions => ["awards.organization_id  = :id and awards.organization_type = 'PhsOrganization'",    {:id => id} ]} }
  named_scope :awards_activity_code_id_equals,        lambda { |id|  {:joins => :awards, :conditions => ["awards.activity_code_id = :id",       {:id => id} ]} }
  named_scope :awards_non_phs_organization_id_equals, lambda { |id|  {:joins => :awards, :conditions => ["awards.organization_id  = :id and awards.organization_type = 'NonPhsOrganization'", {:id => id} ]} }
  
  named_scope :organizational_units_organizational_unit_id_equals, lambda { |id| {:joins => :organizational_units, :conditions => ["organizational_units.id = :id", {:id => id} ]} }
  
  named_scope :all_investigators, :conditions => "((training_type IS NULL) AND (trainee_status IS NULL))"
  named_scope :all_trainees,      :conditions => "((training_type IS NOT NULL OR training_type = '') AND (trainee_status IS NOT NULL OR trainee_status = ''))"
  
  named_scope :for_reporting_year, lambda { |yr| {:conditions => "people.ctsa_reporting_years_mask & #{2**Person::REPORTING_YEARS.index(yr.to_i)} > 0"} }
  
  named_scope :scholars,      :conditions => { :training_type => SCHOLAR, :trainee_status => APPOINTED }
  named_scope :other_careers, :conditions => { :training_type => OTHER_CAREER, :trainee_status => APPOINTED }
  named_scope :trainees,      :conditions => { :training_type => TRAINEE, :trainee_status => APPOINTED }
  
  named_scope :invalid_for_ctsa_reporting, :conditions => "(people.ctsa_reporting_years_mask & #{2**REPORTING_YEARS.index(SYSTEM_CONFIG['current_ctsa_reporting_year'].to_i)} > 0) AND (era_commons_username IS NULL OR specialty_id IS NULL)"
  
  # attributes from faculty_web_service that are not persisted
  attr_accessor :interests, :campus, :descriptions, :dv_abbr
  attr_accessor :basis, :category, :dept_id, :career_track, :degree, :division
  attr_accessor :joint, :rank, :employee_id, :division_id, :pmids, :centers, :secondary
  attr_accessor :demographics, :certifications, :field_of_study
  
  def employee_id=(emplid)
    self.employeeid = emplid if !emplid.blank? && emplid.to_i > 0
  end
  
  def to_s
    "#{full_name}"
  end
  
  def ctsa_name
    "#{last_name}, #{first_name} #{middle_initial}".strip
  end
  
  def middle_initial
    middle_name.to_s.length > 0 ? "#{middle_name[0,1]}." : ""
  end
  
  def full_name
    [first_name, middle_name, last_name].reject { |n| n.nil? or n.blank? }.join(' ')
  end
  
  before_save :clean_or_set_attributes
  
  def clean_or_set_attributes
    set_affiliations
    upcase_era_commons_username
  end
  
  def upcase_era_commons_username
    self.era_commons_username = self.era_commons_username.upcase unless self.era_commons_username.blank?
  end
  
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

  def business_phone=(phone_number)
    self.phone = phone_number
  end
  
  def business_phone
    self.phone
  end
  
  def username=(uname)
    self.netid = uname
  end
  
  def username
    self.netid
  end
  
  def sysadmin?
    self.system_administrator.to_s == "true"
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
  
  def date_of_appointment
    appointment_date.blank? ? "" : appointment_date.strftime('%Y-%m-%d')
  end
  
  def end_date_of_appointment
    end_date.blank? ? "" : end_date.strftime('%Y-%m-%d')    
  end
  
  def mentor_commons_username
    mentor_era_commons_username
  end
  
  def trainee?
    !training_type.blank? && !trainee_status.blank?
  end
  
  def valid_for_ctsa_report?
    result = ctsa_reportable?
    result = !era_commons_username.blank? && !specialty.blank? if result 
    if result && trainee?
      result = !mentor_commons_username.blank?
      result = !degree_1.blank? if result && training_type == TRAINEE && trainee_status == APPOINTED
      result = !date_of_appointment.blank? && !end_date.blank? if result && trainee? && trainee_status == APPOINTED
    end
    result
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
  
  def nu_employee_id=(employeeid)
    self.employeeid = employeeid
  end
  
  def nu_employee_id
    self.employeeid
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

  def era_commons_id=(commons_name)
    self.era_commons_username = commons_name unless commons_name.blank?
  end
  
  def unique_organizational_units
    self.organizational_units.uniq.sort_by { |org| org.abbreviation }
  end

  def applied
    trainee_status.to_s == APPLICANT
  end
  
  def accepted
    trainee_status.to_s == APPOINTED
  end
  
  def interviewed
    false
  end


  ###
  #    Parsing data from CSV
  ###

  def self.import_data(file, user)
    
    FasterCSV.parse(file, :headers => true, :header_converters => :symbol) do |row|
      next if row.header_row?
      if row[:service_lines].blank?
        File.open(import_error_log(user.netid), 'a') {|f| f.write("[#{Time.now.to_s(:db)}] service_lines missing for row - #{row}") }
      elsif row[:era_commons_username].blank? and row[:netid].blank? and row[:employeeid].blank?
        File.open(import_error_log(user.netid), 'a') {|f| f.write("[#{Time.now.to_s(:db)}] unique identifier (netid, employeeid, or era_commons_username) missing for row - #{row}") }
      else
        process_import_row(row, user)
      end
    end
  end
  
  def self.import_error_log(username)
    dir = "#{Rails.root}/log/#{username}"
    FileUtils.makedirs(dir) unless File.exists?(dir)
    log_path = "#{dir}/#{Date.today.strftime('%Y%m%d')}_import_errors.log"
    File.open(log_path, 'w') {|f| f.write("[#{Time.now.to_s(:db)}] UPLOAD ERROR LOG FOR #{username}\n\n") } unless File.exists?(log_path)
    log_path
  end
  
  
  def self.process_import_row(row, user)
    pers = determine_client(row)
  
    if !row[:area_of_expertise].blank?
      specialty = Specialty.find_by_code(row[:area_of_expertise].to_s)
      pers.specialty = specialty unless specialty.nil?
    end

    [:first_name, :last_name, :middle_name, :email, :netid, :employeeid].each { |attribute| pers.send("#{attribute}=", row[attribute]) if !row[attribute].blank? && pers.send("#{attribute}").blank?  }
    pers.organizational_units << user.organizational_unit if !user.organizational_unit.nil? and !pers.organizational_units.include?(user.organizational_unit)

    reporting_years = pers.ctsa_reporting_years
    pers.ctsa_reporting_years = (reporting_years << current_ctsa_reporting_year)
    
    pers = pers.amplify
    
    if pers.valid?
      pers.save!
      process_service_lines_row(pers, row[:service_lines].split(",")) if !row[:service_lines].blank?
    else
      File.open(import_error_log(user.netid), 'a') {|f| f.write("[#{Time.now.to_s(:db)}] person record invalid for - #{row} - #{pers.errors.map(&:to_s)}\n") }
    end
  end
  
  def self.determine_client(row)
    eracn = row[:era_commons_username].to_s.upcase
    netid = row[:netid]
    empid = row[:employeeid]
    email = row[:email]
    
    pers = nil
    
    if pers.blank? && !eracn.blank?
      pers = Person.find_by_era_commons_username(eracn)
    end
    
    if pers.blank? && !netid.blank?
      pers = Person.find_by_netid(netid) 
    end
    if pers.blank? && !email.blank?
      pers = Person.find_by_email(email) 
    end
    if pers.blank? && !empid.blank?
      pers = Person.find_by_employeeid(empid) 
    end
    
    if pers.blank?
      pers = Client.create(:era_commons_username => eracn, :email => email, :netid => netid, :employeeid => empid)
    end
    pers
  end
  
  # process each Service Line in upload file for person
  #   - creates a Service record
  #   - associates the person with the organizational_unit for that service line
  def self.process_service_lines_row(person, service_lines)
    service_lines.each do |name|
      service_line = ServiceLine.find_by_name(name.strip)
      if !service_line.blank?
        create_imported_service(person, service_line)
        update_organizational_unit_associations(person, service_line)
      end
    end
  end
  
  # only create Service if one does not exist
  def self.create_imported_service(person, service_line)
    if Service.first(:conditions => {:person_id => person, :service_line_id => service_line}).blank? 
      svc = Service.create(:person => person, :service_line => service_line)
      svc.update_state
    end
  end
  
  # update org unit associations for person if that person has not yet been associated with that organization
  def self.update_organizational_unit_associations(person, service_line)
    if !service_line.organizational_unit.blank? and !person.organizational_units.include?(service_line.organizational_unit)
      person.organizational_units << service_line.organizational_unit 
      person.save!
    end
  end

  def import_row(row)
  end


  def self.current_ctsa_reporting_year
    year = SYSTEM_CONFIG["current_ctsa_reporting_year"]
    if year.blank?
      year = (Date.today.month == 1) ? Date.today.year - 1 : Date.today.year
    end
    year
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
    unique_organizational_units :to_sentence => "Organizational Units"
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
  
  def amplify
    unless self.edited_by_user
      update_record_via_era_commons_username_map
      if ["staging", "production"].include?(Rails.env)
        update_record_via_bcsec
      end
    end
    self
  end
  
  private
  
    def update_record_via_bcsec
      criteria = []
      criteria << {:nu_employee_id => self.employeeid} if self.employeeid
      criteria << {:username       => self.netid}      if self.netid
      
      unless criteria.empty?
        
        usrs = Bcsec.authority.find_users(*criteria)
        if !usrs.blank?
          if usr = usrs.first
            Bcsec::User::ATTRIBUTES.each do |a|
              next if a.to_s.downcase == "country"
              self.send("#{a}=", usr.send("#{a}").to_s) if self.respond_to?("#{a}=") && self.send("#{a}").blank?
            end
          end

          update_record_via_era_commons_username_map
        end
      end
    end
  
    def update_record_via_era_commons_username_map
      map = DataScrubber.get_commons_name_map_from_file

      if self.era_commons_username
        self.employeeid = map[self.era_commons_username] if self.employeeid.blank?
      end
      
      if self.employeeid
        self.era_commons_username = map[self.employeeid] if self.era_commons_username.blank?
      end
    end
  
end
