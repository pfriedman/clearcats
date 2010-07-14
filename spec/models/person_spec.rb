# == Schema Information
# Schema version: 20100702191146
#
# Table name: people
#
#  id                     :integer         not null, primary key
#  first_name             :string(255)
#  middle_name            :string(255)
#  last_name              :string(255)
#  netid                  :string(255)
#  email                  :string(255)
#  department_affiliation :string(255)
#  school_affiliation     :string(255)
#  last_four_of_ssn       :string(255)
#  phone                  :string(255)
#  era_commons_username   :string(255)
#  department_id          :integer
#  created_at             :datetime
#  updated_at             :datetime
#

require 'spec_helper'

describe Person do
  it "should create a new instance given valid attributes" do
    Factory(:person)
  end
  
  it "should override to_s to show a user friendly representation" do
    p = Factory(:person, :last_name => "Jefferson", :first_name => "Thomas")
    p.to_s.should == "Thomas Jefferson"
  end
  
  it "should set affiliations based on department" do
    dept = Factory(:department, :entity_name => "dept entity name", :school => "dept school")
    p = Factory(:person, :department => dept)
    p.department_affiliation.should == "dept entity name"
    p.school_affiliation.should == "dept school"
  end
  
  it { should ensure_length_of(:last_four_of_ssn) }
  
  it { should belong_to(:department) }
  
  it { should belong_to(:country) }
  it { should belong_to(:degree_type_one) }
  it { should belong_to(:degree_type_two) }
  it { should belong_to(:specialty) }
  it { should belong_to(:ethnic_type) }
  it { should belong_to(:race_type) }
  
  it { should have_and_belong_to_many(:institution_positions) }
  
  # it { should have_many(:awards) }
  # it { should have_many(:publications) }
  
  # context "with awards" do
  #   
  #   it "should find awards for a particular ctsa_award_type" do
  #     person      = Factory(:person)
  #     phs_org     = Factory(:phs_organization)
  #     non_phs_org = Factory(:non_phs_organization)
  #     activity    = Factory(:activity_code) 
  #     award       = Factory(:award, :ctsa_award_type => activity, :person => person)
  #     
  #     person.awards.should_not be_empty
  #     person.awards.first.should == award
  #     
  #     award_for_ctsa_award_type = person.awards_for_ctsa_award_type(non_phs_org)
  #     award_for_ctsa_award_type.should be_empty
  #     
  #     award_for_ctsa_award_type = person.awards_for_ctsa_award_type(phs_org)
  #     award_for_ctsa_award_type.should be_empty
  #     
  #     award_for_ctsa_award_type = person.awards_for_ctsa_award_type(activity)
  #     award_for_ctsa_award_type.should_not be_empty
  #     
  #   end
  #   
  # end
  
  
end
