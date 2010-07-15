# == Schema Information
# Schema version: 20100714190938
#
# Table name: people
#
#  id                       :integer         not null, primary key
#  first_name               :string(255)
#  middle_name              :string(255)
#  last_name                :string(255)
#  netid                    :string(255)
#  email                    :string(255)
#  department_affiliation   :string(255)
#  school_affiliation       :string(255)
#  last_four_of_ssn         :string(255)
#  phone                    :string(255)
#  era_commons_username     :string(255)
#  employeeid               :string(255)
#  department_id            :integer
#  degree_type_one_id       :integer
#  degree_type_two_id       :integer
#  specialty_id             :integer
#  country_id               :integer
#  ethnic_type_id           :integer
#  race_type_id             :integer
#  disadvantaged_background :boolean
#  created_at               :datetime
#  updated_at               :datetime
#

class Person < ActiveRecord::Base
  
  belongs_to :department

  # has_many :awards
  # has_many :publications
  has_and_belongs_to_many :institution_positions
    
  belongs_to :country
  belongs_to :degree_type_one
  belongs_to :degree_type_two
  belongs_to :specialty
  belongs_to :ethnic_type
  belongs_to :race_type

  validates_length_of :last_four_of_ssn, :is => 4, :if => proc { |obj| !obj.last_four_of_ssn.blank? }
  
  # accepts_nested_attributes_for :awards, :allow_destroy => true
  # accepts_nested_attributes_for :publications, :allow_destroy => true
  
  # attributes from faculty_web_service that are not persisted
  attr_accessor :interests, :campus, :descriptions, :dv_abbr
  attr_accessor :basis, :category, :dept_id, :career_track, :degree, :division
  attr_accessor :joint, :rank, :employee_id, :division_id, :pmids, :centers, :secondary
  
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
  
  # def awards_for_ctsa_award_type(ctsa_award_type)
  #   self.awards.all(:conditions => { :ctsa_award_type_id => ctsa_award_type.id, :ctsa_award_type_type =>  ctsa_award_type.class.to_s })
  # end
  
end
