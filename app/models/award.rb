# == Schema Information
# Schema version: 20100727181206
#
# Table name: awards
#
#  id                                     :integer         not null, primary key
#  grant_number                           :string(255)
#  years_of_award                         :string(255)
#  grant_title                            :string(2500)
#  grant_amount                           :float
#  person_id                              :integer
#  investigator_id                        :integer
#  role                                   :string(255)
#  parent_institution_number              :string(255)
#  institution_number                     :string(255)
#  subproject_number                      :string(255)
#  ctsa_award_type_award_number           :string(255)
#  budget_period                          :string(255)
#  budget_period_start_date               :date
#  budget_period_end_date                 :date
#  budget_period_direct_cost              :float
#  budget_period_direct_and_indirect_cost :float
#  project_period_start_date              :date
#  project_period_end_date                :date
#  project_period_total_cost              :float
#  total_project_cost                     :float
#  ctsa_award_type_id                     :integer
#  ctsa_award_type_type                   :string(255)
#  proposal_status                        :string(255)
#  award_status                           :string(255)
#  sponsor_award_number                   :string(255)
#  budget_number                          :string(255)
#  direct_amount                          :float
#  indirect_amount                        :float
#  total_amount                           :float
#  nucats_assisted                        :boolean
#  created_at                             :datetime
#  updated_at                             :datetime
#  sponsor_id                             :integer
#  originating_sponsor_id                 :integer
#

class Award < ActiveRecord::Base
  belongs_to :person
  belongs_to :ctsa_award_type, :polymorphic => true
  
  belongs_to :sponsor

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
  
  def award_begin_date=(dt)
    self.budget_period_start_date = dt
  end
  
  def award_end_date=(dt)
    self.budget_period_end_date = dt
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
  
  # CTSA award type 
  
  def phs_organization=(id)
    if !id.blank?
      self.ctsa_award_type_id = id.to_i
      self.ctsa_award_type_type = "PhsOrganization"
    end
  end
  
  def non_phs_organization=(id)
    if !id.blank?
      self.ctsa_award_type_id = id.to_i
      self.ctsa_award_type_type = "NonPhsOrganization"
    end
  end
  
  def activity_code=(id)
    if !id.blank?
      self.ctsa_award_type_id = id.to_i
      self.ctsa_award_type_type = "ActivityCode"
    end
  end
  
  def phs_organization
    ctsa_award_type if ctsa_award_type and ctsa_award_type.type == "PhsOrganization"
  end
  
  def non_phs_organization
    ctsa_award_type if ctsa_award_type and ctsa_award_type.type == "NonPhsOrganization"
  end
  
  def activity_code
    ctsa_award_type if ctsa_award_type and ctsa_award_type.type == "ActivityCode"
  end
  
end
