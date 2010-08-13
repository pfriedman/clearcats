# == Schema Information
# Schema version: 20100727181206
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
#

require 'comma'
class Person < ActiveRecord::Base
  
  belongs_to :department

  has_many :services
  has_many :awards
  has_many :publications
  has_many :approvals
  has_and_belongs_to_many :institution_positions
    
  belongs_to :country
  belongs_to :degree_type_one
  belongs_to :degree_type_two
  belongs_to :specialty
  belongs_to :ethnic_type
  belongs_to :race_type

  validates_length_of :last_four_of_ssn, :is => 4, :if => proc { |obj| !obj.last_four_of_ssn.blank? }
  
  accepts_nested_attributes_for :awards, :allow_destroy => true
  accepts_nested_attributes_for :publications, :allow_destroy => true
  accepts_nested_attributes_for :approvals, :allow_destroy => true
  
  named_scope :awards_phs_organization_id_equals, lambda { |id| {:joins => :awards, :conditions => ["awards.ctsa_award_type_id = :id and awards.ctsa_award_type_type = 'PhsOrganization'", {:id => id} ]} }
  named_scope :awards_activity_code_id_equals, lambda { |id| {:joins => :awards, :conditions => ["awards.ctsa_award_type_id = :id and awards.ctsa_award_type_type = 'ActivityCode'", {:id => id} ]} }
  named_scope :awards_non_phs_organization_id_equals, lambda { |id| {:joins => :awards, :conditions => ["awards.ctsa_award_type_id = :id and awards.ctsa_award_type_type = 'NonPhsOrganization'", {:id => id} ]} }

  # attributes from faculty_web_service that are not persisted
  attr_accessor :interests, :campus, :descriptions, :dv_abbr
  attr_accessor :basis, :category, :dept_id, :career_track, :degree, :division
  attr_accessor :joint, :rank, :employee_id, :division_id, :pmids, :centers, :secondary
  attr_accessor :demographics
  
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
  
  def awards_for_ctsa_award_type(ctsa_award_type)
    self.awards.all(:conditions => { :ctsa_award_type_id => ctsa_award_type.id, :ctsa_award_type_type =>  ctsa_award_type.class.to_s })
  end

  # Support for exporting to csv
  comma do
    last_name
    first_name
    netid
    email
    employeeid
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
