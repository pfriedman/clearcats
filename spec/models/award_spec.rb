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

require 'spec_helper'

describe Award do

  it "should create a new instance given valid attributes" do
    Factory(:award)
  end
  
  it "should describe itself in a human readable format" do
    award = Factory(:award)
    award.to_s.should == "#{award.sponsor_name} - #{award.sponsor_award_number} [#{award.grant_title}]"
  end
  
  it "should report missing fields for the ctsa report" do
    award = Factory(:award, :activity_code => nil, :grant_number => nil, :organization => nil)
    award.ctsa_missing_fields.should == "Activity Code, Grant Number, Organization"
  end
  
  it { should belong_to(:person) }
  it { should belong_to(:organization) }
  it { should belong_to(:activity_code) }
  it { should belong_to(:sponsor) }
  it { should have_many(:award_details) }
  
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
    
    it "should defer to the organzation when asking for phs or non phs ids" do
      award = Factory(:award)
      award.phs_organization_id.should == award.organization.id
      award.non_phs_organization_id.should == award.organization.id
    end
    
  end
  
end
