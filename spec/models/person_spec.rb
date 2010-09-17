# == Schema Information
# Schema version: 20100915163558
#
# Table name: people
#
#  id                                            :integer         not null, primary key
#  type                                          :string(255)
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
#  personnelid                                   :string(255)
#  address                                       :string(255)
#  city                                          :string(255)
#  state                                         :string(255)
#  organizational_unit_id                        :integer
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
#  service_rendered                              :boolean
#  training_type                                 :string(255)
#  trainee_status                                :string(255)
#  has_disability                                :boolean
#  gender                                        :string(255)
#  title                                         :string(255)
#  fax                                           :string(255)
#  edited                                        :boolean
#  imported                                      :boolean
#  ctsa_reporting_years_mask                     :integer
#

require 'spec_helper'

describe Person do
  it "should create a new instance given valid attributes" do
    Factory(:person)
  end
  
  it "should override to_s to show a user friendly representation" do
    p = Factory(:person, :last_name => "Jefferson", :first_name => "Thomas", :middle_name => "A")
    p.to_s.should == "Thomas A Jefferson"
  end
  
  it "should output in a csv format" do
    p = Factory(:person, :last_name => "Jefferson", :first_name => "Thomas")
    p.to_comma.should == ["Jefferson", "Thomas", "middle_name", "#{p.netid}", "#{p.email}", "phone", "", "era_commons", "dept", "school", "four", "dt1 name", "dt2 name", "specialty code specialty name", "country name", "", "", "", "", "", "", "", ""]
  end
  
  it "should set affiliations based on department" do
    dept = Factory(:department, :entity_name => "dept entity name", :school => "dept school")
    p = Factory(:person, :department => dept)
    p.department_affiliation.should == "dept entity name"
    p.school_affiliation.should == "dept school"
  end
  
  it "should set attributes from ldap" do
    netid = "wakibbe"
    pers = Factory(:person, :netid => netid, :phone => "")
    pers.phone.should be_blank
    
    ldap_entry = Ldap.new.retrieve_entry(netid)
    ldap_entry.attribute_names.each { |key| pers.send("#{key}=", ldap_entry[key]) if pers.respond_to?("#{key}=") }
    pers.phone.should_not be_blank
  end
  
  context "finding people of a particular reporting type" do
  
    before(:each) do
      @investigator = Factory(:person, :training_type => nil, :netid => "netid_i")
      @trainee      = Factory(:person, :training_type => Person::SCHOLAR, :trainee_status => Person::APPOINTED, :netid => "netid_t")
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
  it { should have_and_belong_to_many(:organizational_units) }
  
  it { should have_many(:awards) }
  it { should have_many(:publications) }
  it { should have_many(:approvals) }
  it { should have_many(:services) }
  
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:email) }
  
  describe "a person who does not have a netid" do 
    before(:each) do
      @subject = Factory(:person, :netid => nil, :era_commons_username => "asdf")
    end

    it { should validate_presence_of(:era_commons_username) }
  end
  
  describe "a person who does not have an era commons username" do 
    before(:each) do
      @subject = Factory(:person, :era_commons_username => nil, :netid => "asdf")
    end

    it { should validate_presence_of(:netid) }
  end
  
  context "with awards" do
    
    it "should find awards for a particular organization" do
      person      = Factory(:person)
      activity    = Factory(:activity_code)
      phs_org     = Factory(:phs_organization)
      non_phs_org = Factory(:non_phs_organization)
      award       = Factory(:award, :organization => phs_org, :person => person, :activity_code => activity)
      
      person.awards.should_not be_empty
      person.awards.size.should == 1
      person.awards.first.should == award
      
      person.awards_for_organization(non_phs_org).should be_empty
      person.awards_for_organization(phs_org).should_not be_empty
      
      Person.awards_activity_code_id_equals(activity.id).should_not be_empty
    end
    
  end
  
  context "uploading csv data" do
    
    describe "processing a valid csv document" do
      
      it "should create Person records from the data" do
        Person.count.should == 0
        usr = Factory(:user)
        Person.import_data(File.open(File.expand_path(File.dirname(__FILE__) + '/../data/valid_person_upload.csv')), usr)
        
        Person.count.should == 3
        User.count.should   == 1
      end
      
      it "should associate Person with organizational units of the uploader" do
        Person.count.should == 0
        org_unit = Factory(:organizational_unit, :abbreviation => "NUCATS", :name => "Clinical and Translational Sciences Institute")
        usr = Factory(:user, :organizational_unit => org_unit)
        Person.import_data(File.open(File.expand_path(File.dirname(__FILE__) + '/../data/valid_person_upload.csv')), usr)
        
        Person.count.should == 3
        User.count.should   == 1
        Person.last.organizational_units.should == [org_unit]
      end
      
      # "service line name"
      
    end
    
  end
  
  context "audit history" do
    
    it "should output all versioning history" do
      person = Factory(:person)
      version_attributes = {"created_at"=> Time.now, 
                            "whodunnit"=>"cc_admin", 
                            "event"=>"update", 
                            "object"=>'--- \nrace_type_id: \naddress: |-\n  RUBLOFF 750 N Lake Shore Dr\n  11th Floor\ncreated_at: 2010-08-26 21:28:06.515240 Z\ntrainee_status: ""\ntitle: Associate Professor\nservice_rendered: false\nera_commons_username: ""\nemployeeid: "1010101"\ndegree_type_two_id: \nupdated_at: 2010-08-26 21:28:06.515240 Z\nhas_disability: \nlast_four_of_ssn: \ncountry_id: \nid: 1\ngender: \ndepartment_affiliation: ""\nnetid: netid\nschool_affiliation: ""\nphone: +1 312 503 5033\nlast_name: Guy\nfax: \nspecialty_id: \ndegree_type_one_id: \ntraining_type: ""\nhuman_subject_protection_training_institution: \nhuman_subject_protection_training_date: \nethnic_type_id: \nmiddle_name: X\nfirst_name: Some\nemail: someguy@northwestern.edu\ndisadvantaged_background: \ndepartment_id: \n', 
                            "item_id"=>person.id, "item_type"=>"Person"}
      person.versions << Version.create(version_attributes)
      
      csv = person.export_versions
      csv.should_not be_blank
      arr_of_arrs = FasterCSV.parse(csv)
      arr_of_arrs[0][0].should == "When"
      arr_of_arrs[0][1].should == "Who"
      arr_of_arrs[1][1].should == "cc_admin"
    end
    
  end
  
end
