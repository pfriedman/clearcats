# == Schema Information
# Schema version: 20100714190938
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

require 'spec_helper'

describe Award do

  it "should create a new instance given valid attributes" do
    Factory(:award)
  end
  
  it { should belong_to(:person) }
  it { should belong_to(:ctsa_award_type) }
#  it { should belong_to(:sponsor) }
  
end
