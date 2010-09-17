class Turbocats::PhsFunding < Turbocats::Base
  set_table_name 'phs_fundings'
  set_primary_key 'id'
  
  acts_as_importable
  
  # TurboCats
  # investigator_id, phs_organization_code, activity_code, six_digit_grant_number, invalid, validation_messages, reporting_year
  #
  # ClearCats
  # grant_number, years_of_award, grant_title, grant_amount, person_id
  # investigator_id, role, parent_institution_number, institution_number
  # subproject_number, ctsa_award_type_award_number 
  # budget_period, budget_period_start_date, budget_period_end_date
  # budget_period_direct_cost, budget_period_direct_and_indirect_cost
  # project_period_start_date, project_period_end_date, project_period_total_cost, total_project_cost
  # organization_id, organization_type, proposal_status, award_status, sponsor_award_number
  # budget_number, direct_amount, indirect_amount, total_amount, nucats_assisted, sponsor_id, originating_sponsor_id
  def to_model
    tcp = Turbocats::Investigator.find(self.investigator_id)
    return nil if tcp.blank?
    ::Award.new do |a|
      # import the person association
      a.nucats_assisted      = true
      a.person               = ::Person.find_by_era_commons_username(tcp.commons_username)
      a.organization         = PhsOrganization.find_by_code(self.phs_organization_code)
      a.activity_code        = ActivityCode.find_by_code(self.activity_code)
      a.grant_number         = self.six_digit_grant_number
      a.budget_identifier    = "turbocats_import_#{self.ctsa_reporting_year.first}_#{self.six_digit_grant_number}"
      a.ctsa_reporting_years = self.ctsa_reporting_year
    end
  end

  def ctsa_reporting_year
    self.reporting_year.blank? ? [2009] : [self.reporting_year.to_i]
  end
end