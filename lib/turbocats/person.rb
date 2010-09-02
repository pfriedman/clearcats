
require 'activesupport'
class Turbocats::Person < Turbocats::Base
  set_table_name 'people'
  set_primary_key 'id'
  
  acts_as_importable
  
  def to_s
    "[#{self.id}] #{self.last_name}, #{self.first_name}"
  end

  # TurboCats
  # mentor_commons_username, interviewed, invalid, reporting_year, id, type, updated_by, validation_messages, end_date, accepted, date_of_appointment
  #
  # ClearCats
  #  netid, email, department_affiliation, school_affiliation, last_four_of_ssn, phone, employeeid
  #  department_id, country_id, human_subject_protection_training_institution, human_subject_protection_training_date 
  #  service_rendered, title, fax, address
  def to_model
    ::Person.new do |p|
      p.imported = true
    
      p.first_name                = self.first_name                                     unless self.first_name.blank?
      p.last_name                 = self.last_name                                      unless self.last_name.blank?
      p.middle_name               = self.middle_initial                                 unless self.middle_initial.blank?
    
      p.era_commons_username      = self.commons_username                               unless self.commons_username.blank?
      p.gender                    = self.gender.titleize                                unless self.gender.blank?
      p.has_disability            = self.has_disability
      p.disadvantaged_background  = self.disadvantaged_background
      p.training_type             = self.training_type                                  unless self.training_type.blank?
    
      p.trainee_status            = ::Person::APPLICANT                                 if self.applied
      p.trainee_status            = ::Person::APPOINTED                                 if self.appointed
    
      p.specialty                 = Specialty.find_by_code(self.area_of_expertise_code) unless self.area_of_expertise_code.blank?
      p.race_type                 = RaceType.find_by_name(self.racial_category)         unless self.racial_category.blank?
      p.ethnic_type               = EthnicType.find_by_name(self.ethnic_category)       unless self.ethnic_category.blank?
      p.degree_type_one           = DegreeTypeOne.find_by_name(self.degree_1)           unless self.degree_1.blank?
      p.degree_type_two           = DegreeTypeTwo.find_by_name(self.degree_2)           unless self.degree_2.blank?
    end
  end
end