# == Schema Information
# Schema version: 20101202161044
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

class Award < ActiveRecord::Base
  include VersionExportable
  include CtsaReportable
  
  has_paper_trail :ignore => [:ctsa_reporting_years_mask]
  
  named_scope :all_for_reporting_year, lambda { |yr| {:conditions => "ctsa_reporting_years_mask & #{2**REPORTING_YEARS.index(yr.to_i)} > 0 "} }
  named_scope :invalid_for_ctsa, :conditions => "organization_id IS NULL OR activity_code_id IS NULL OR grant_number IS NULL"
  
  belongs_to :person
  belongs_to :organization
  belongs_to :activity_code
  belongs_to :sponsor
  has_many :award_details
    
  validates_presence_of :budget_identifier
  
  # attributes from faculty_web_service that are not persisted
  attr_accessor :nu_employee_id, :first_name, :last_name, :middle_name
  attr_accessor :proposal_flag, :modified_date, :cufs_fund, :cufs_area, :cufs_org, :restricted_budget_amount
  attr_accessor :load_date, :moved_to_projects, :department, :orig_sponsor_code_l3, :orig_sponsor_name_l3
  attr_accessor :sponsor_name

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
    result << "Activity Code" if self.activity_code_id.blank?
    result << "Grant Number"  if self.grant_number.blank?
    result << "Organization"  if self.organization_id.blank?
    result.join(", ")
  end
  
end
