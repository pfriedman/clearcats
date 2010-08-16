# == Schema Information
# Schema version: 20100727181206
#
# Table name: people
#
#  id                                            :integer         not null, primary key
#  first_name                                    :string(255)
#  middle_name                                   :string(255)
#  last_name                                     :string(255)
#  netid                                         :string(255)
#  email                                         :string(255)
#  department_affiliation                        :string(255)
#  school_affiliation                            :string(255)
#  last_four_of_ssn                              :string(255)
#  phone                                         :string(255)
#  era_commons_username                          :string(255)
#  employeeid                                    :string(255)
#  department_id                                 :integer
#  degree_type_one_id                            :integer
#  degree_type_two_id                            :integer
#  specialty_id                                  :integer
#  country_id                                    :integer
#  ethnic_type_id                                :integer
#  race_type_id                                  :integer
#  disadvantaged_background                      :boolean
#  created_at                                    :datetime
#  updated_at                                    :datetime
#  human_subject_protection_training_institution :string(255)
#  human_subject_protection_training_date        :date
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
  
  it "should output in a csv format" do
    p = Factory(:person, :last_name => "Jefferson", :first_name => "Thomas")
    p.to_comma.should == ["Jefferson", "Thomas", "middle_name", "", "#{p.email}", "phone", "", "era_commons", "dept", "school", "four", "dt1 name", "dt2 name", "specialty code specialty name", "country name", "", "", "", "", "", "", ""]
  
  end
  
  it "should set affiliations based on department" do
    dept = Factory(:department, :entity_name => "dept entity name", :school => "dept school")
    p = Factory(:person, :department => dept)
    p.department_affiliation.should == "dept entity name"
    p.school_affiliation.should == "dept school"
  end
  
  context "finding people of a particular reporting type" do
  
    before(:each) do
      @investigator = Factory(:person, :training_type => nil)
      @trainee      = Factory(:person, :training_type => Person::SCHOLAR, :appointed_trainee => true)
    end
  
    it "should retrieve all investigators" do
      investigators = Person.all_investigators
      investigators.should_not be_empty
      investigators.size.should == 1
      investigators.first.should == @investigator
    end
  
    it "should retrieve all trainees" do
      trainees = Person.all_trainees
      trainees.should_not be_empty
      trainees.size.should == 1
      trainees.first.should == @trainee
    end
  
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
  
  it { should have_many(:awards) }
  it { should have_many(:publications) }
  it { should have_many(:approvals) }
  it { should have_many(:services) }
  
  context "with awards" do
    
    it "should find awards for a particular ctsa_award_type" do
      person      = Factory(:person)
      phs_org     = Factory(:phs_organization)
      non_phs_org = Factory(:non_phs_organization)
      activity    = Factory(:activity_code) 
      award       = Factory(:award, :ctsa_award_type => activity, :person => person)
      
      person.awards.should_not be_empty
      person.awards.first.should == award
      
      award_for_ctsa_award_type = person.awards_for_ctsa_award_type(non_phs_org)
      award_for_ctsa_award_type.should be_empty
      
      award_for_ctsa_award_type = person.awards_for_ctsa_award_type(phs_org)
      award_for_ctsa_award_type.should be_empty
      
      award_for_ctsa_award_type = person.awards_for_ctsa_award_type(activity)
      award_for_ctsa_award_type.should_not be_empty
      
    end
    
  end
  
end
