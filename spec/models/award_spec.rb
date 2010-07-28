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

require 'spec_helper'

describe Award do

  it "should create a new instance given valid attributes" do
    Factory(:award)
  end
  
  it { should belong_to(:person) }
  it { should belong_to(:ctsa_award_type) }
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
  
  context "the ctsa award types" do
    
    before(:each) do
      @phs_org       = Factory(:phs_organization)
      @non_phs_org   = Factory(:non_phs_organization)
      @activity_code = Factory(:activity_code)
    end
    
    it "should set the ctsa award type by type" do
      award = Factory(:award, :ctsa_award_type => nil)
      award.ctsa_award_type.should be_nil
      
      award.phs_organization = @phs_org.id
      award.ctsa_award_type.should == award.phs_organization

      award.non_phs_organization = @non_phs_org.id
      award.ctsa_award_type.should == award.non_phs_organization

      award.activity_code = @activity_code.id
      award.ctsa_award_type.should == award.activity_code
    end
    
  end
  
end
