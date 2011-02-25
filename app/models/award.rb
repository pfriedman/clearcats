# == Schema Information
# Schema version: 20101216175350
#
# Table name: awards
#
#  id                           :integer         not null, primary key
#  grant_number                 :string(255)
#  grant_title                  :string(2500)
#  grant_amount                 :float
#  person_id                    :integer
#  investigator_id              :integer
#  role                         :string(255)
#  parent_institution_number    :string(255)
#  institution_number           :string(255)
#  subproject_number            :string(255)
#  ctsa_award_type_award_number :string(255)
#  project_period_start_date    :date
#  project_period_end_date      :date
#  project_period_total_cost    :float
#  total_project_cost           :float
#  organization_id              :integer
#  organization_type            :string(255)
#  activity_code_id             :integer
#  proposal_status              :string(255)
#  award_status                 :string(255)
#  sponsor_award_number         :string(255)
#  nucats_assisted              :boolean
#  budget_identifier            :string(255)
#  edited_by_user               :boolean
#  created_at                   :datetime
#  updated_at                   :datetime
#  sponsor_id                   :integer
#  originating_sponsor_id       :integer
#  ctsa_reporting_years_mask    :integer
#  created_by                   :string(255)
#  updated_by                   :string(255)
#

require 'comma'
class Award < ActiveRecord::Base
  include VersionExportable
  include CtsaReportable
  
  has_paper_trail :ignore => [:ctsa_reporting_years_mask]
  
  named_scope :nucats_assisted_eq, lambda { |flag| {:conditions => "awards.nucats_assisted IS TRUE"} if (flag == "1" || flag.to_i == 1 || flag == true)}
  named_scope :all_for_reporting_year, lambda { |yr| {:conditions => "awards.ctsa_reporting_years_mask & #{2**REPORTING_YEARS.index(yr.to_i)} > 0 "} }
  named_scope :invalid_for_ctsa, :joins => "LEFT OUTER JOIN organizations ON organizations.id = awards.organization_id", 
    :conditions => "(awards.ctsa_reporting_years_mask & #{2**REPORTING_YEARS.index(SYSTEM_CONFIG['current_ctsa_reporting_year'].to_i)} > 0) AND " +
    "(" +
    "  (organization_id IS NULL) " +
    "  OR " +
    "  (organization_id IS NOT NULL and organizations.type = 'PhsOrganization' and activity_code_id IS NULL)" +
    "  OR " +
    "  (organization_id IS NOT NULL and organizations.type = 'PhsOrganization' and (grant_number IS NULL OR grant_number = ''))" +
    ")"
  
  named_scope :phs_organization_id_equals, lambda { |id| {:conditions => "organization_id = #{id.to_i}"} }
  named_scope :non_phs_organization_id_equals, lambda { |id| {:conditions => "organization_id = #{id.to_i}"} }
  
  belongs_to :person
  belongs_to :organization
  belongs_to :activity_code
  belongs_to :sponsor
  has_many :award_details
  
  # attributes from faculty_web_service that are not persisted
  attr_accessor :nu_employee_id, :first_name, :last_name, :middle_name
  attr_accessor :proposal_flag, :modified_date, :cufs_fund, :cufs_area, :cufs_org, :restricted_budget_amount
  attr_accessor :load_date, :moved_to_projects, :department, :orig_sponsor_code_l3, :orig_sponsor_name_l3
  attr_accessor :sponsor_name
  
  before_save :set_ctsa_award_type_award_number

  
  def set_ctsa_award_type_award_number
    self.ctsa_award_type_award_number = SYSTEM_CONFIG["grant_number"] if self.ctsa_reportable?
  end

  #### MAPPING OF FIELDS FROM cc_admin_holding ####
  
  def project_begin_date=(dt)
    self.project_period_start_date = dt
  end
  
  def project_end_date=(dt)
    self.project_period_end_date = dt
  end
  
  def proposal_title=(title)
    self.grant_title = title
  end
  
  def inst_num=(num)
    self.institution_number = num
  end
  
  def parent_inst_num=(num)
    self.parent_institution_number = num
  end
  
  # Sponsor
  
  def sponsor_name
    self.sponsor.to_s
  end
  
  def sponsor_name=(sponsor_name)
    self.sponsor = Sponsor.find_or_create_by_name(sponsor_name)
  end
  
  def to_s
    "#{sponsor_name} - #{sponsor_award_number} [#{grant_title}]"
  end
  
  # CTSA award organization 
  
  def phs_organization=(org_id)
    self.phs_organization_id = org_id
  end
  
  def phs_organization_id=(org_id)
    self.organization = PhsOrganization.find(org_id) unless org_id.blank?
  end
  
  def non_phs_organization=(org_id)
    self.non_phs_organization_id = org_id
  end
  
  def non_phs_organization_id=(org_id)
    self.organization = NonPhsOrganization.find(org_id) unless org_id.blank?
  end
  
  def phs_organization
    organization if organization and organization.type == "PhsOrganization"
  end

  def phs_organization_id
    organization.id if organization
  end

  def non_phs_organization
    organization if organization and organization.type == "NonPhsOrganization"
  end

  def non_phs_organization_id
    organization.id if organization
  end
  
  # formatted date fields  
  def formatted_project_period_start_date
    self.project_period_start_date.strftime("%m/%d/%Y") unless self.project_period_start_date.nil?
  end
  
  def formatted_project_period_start_date=(dt)
    self.project_period_start_date = dt
  end

  def formatted_project_period_end_date
    self.project_period_end_date.strftime("%m/%d/%Y") unless self.project_period_end_date.nil?
  end
  
  def formatted_project_period_end_date=(dt)
    self.project_period_end_date = dt
  end
  
  def ctsa_missing_fields
    result = []
    result << "Organization"  if organization_id.blank?
    result << "Activity Code" if activity_code_id.blank? && (!organization.blank? and organization.type == "PhsOrganization")
    result << "Grant Number"  if grant_number.blank? && (!organization.blank? and organization.type == "NonPhsOrganization")
    result.join(", ")
  end
  
  def valid_for_ctsa_report?
    result = ctsa_missing_fields.blank?
    result = ((/\d{6}/ =~ grant_number) && (grant_number.length == 6)) if result && !grant_number.blank?
    result = false if grant_number.blank? && (!organization.blank? and organization.type == "PhsOrganization")
    result
  end
  
  def total_amount
    self.award_details.map(&:total_amount).sum
  end
  
  ###
  #    Support for exporting to CSV
  ###
  
  comma do
    person
    grant_number
    grant_title
    grant_amount
    parent_institution_number
    institution_number
    subproject_number
    ctsa_award_type_award_number
    project_period_start_date
    project_period_end_date
    project_period_total_cost
    total_project_cost
    organization
    activity_code
    proposal_status
    award_status
    sponsor_award_number
    nucats_assisted
    budget_identifier
    sponsor
    ctsa_reporting_years :to_sentence => "CTSA Reporting Years"
  end
  
end
