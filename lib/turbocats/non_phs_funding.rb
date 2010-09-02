class Turbocats::NonPhsFunding < Turbocats::Base
  set_table_name 'non_phs_fundings'
  set_primary_key 'id'
  
  acts_as_importable
  
  # TurboCats
  #  investigator_id, non_phs_organization_code, grant_contract_number, grant_title
  #  total_dollars, invalid, validation_messages, reporting_year
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
      a.nucats_assisted = true
      a.person          = ::Person.find_by_era_commons_username(tcp.commons_username)
      a.organization    = NonPhsOrganization.find_by_code(self.non_phs_organization_code)
      a.grant_number    = self.grant_contract_number
      a.grant_title     = self.grant_title
      a.total_amount    = self.total_dollars
      a.years_of_award  = self.reporting_year.to_s             # TODO: confirm this attribute
    end
  end
end
