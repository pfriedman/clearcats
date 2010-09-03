# == Schema Information
# Schema version: 20100903173011
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
#  organization_id                        :integer
#  organization_type                      :string(255)
#  activity_code_id                       :integer
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
  it { should belong_to(:organization) }
  it { should belong_to(:activity_code) }
  it { should belong_to(:sponsor) }
  
  context "the award sponsor" do
    
    it "should create the sponsor if one does not already exist" do
      Sponsor.count.should == 0
      
      award = Factory(:award)
      award.sponsor_name = "asdf"
      
      Sponsor.count.should == 1
      award.sponsor_name.should == Sponsor.first.name
    end
    
    it "should use the sponsor if it exists" do
      sponsor = Factory(:sponsor)
      Sponsor.count.should == 1
      
      award = Factory(:award)
      award.sponsor_name = sponsor.name
      
      Sponsor.count.should == 1
    end
    
  end
  
  context "the organizations" do
    
    before(:each) do
      @phs_org       = Factory(:phs_organization)
      @non_phs_org   = Factory(:non_phs_organization)
    end
    
    it "should set the organization by type" do
      award = Factory(:award, :organization => nil)
      award.organization.should be_nil
      
      award.phs_organization = @phs_org.id.to_s
      award.organization.should == award.phs_organization

      @non_phs_org.id.to_s.should_not be_blank
      award.non_phs_organization = @non_phs_org.id.to_s
      award.organization.should == award.non_phs_organization
    end
    
  end
  
end
