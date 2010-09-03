require 'spec_helper'

describe CtsaSchemaReader do
  
  before(:each) do
    @file_path = File.expand_path(File.dirname(__FILE__) + '/../data/2010 CTSA XML Schema.xsd')
    @reader = CtsaSchemaReader.new(@file_path)
  end
  
  it "should initialize a new CtsaSchemaReader" do
    @reader.should_not be_nil
  end
  
  context "creating models from file data" do
    
    it "should create activity codes" do
      ActivityCode.count.should == 0
      @reader.process_activity_codes
      ActivityCode.count.should_not == 0

      activity_codes = ActivityCode.all(:order => :code)
      
      activity_codes.first.code.should == "B01"
      activity_codes.first.name.should == "Preventive Health Services"
    end

    it "should create non-phs organizations" do
      NonPhsOrganization.count.should == 0
      @reader.process_non_phs_organizations
      NonPhsOrganization.count.should_not == 0

      orgs = NonPhsOrganization.all(:order => :code)

      orgs.first.code.should == "ACF"
      orgs.first.name.should == "Administration for Children and Families"
    end

    it "should create phs organizations" do
      PhsOrganization.count.should == 0
      @reader.process_phs_organizations
      PhsOrganization.count.should_not == 0
      
      orgs = PhsOrganization.all(:order => :code)

      orgs.first.code.should == "AA"
      orgs.first.name.should == "National Institute on Alcohol Abuse and Alcoholism"
    end
    
    it "should create countries" do
      Country.count.should == 0
      @reader.process_countries
      Country.count.should_not == 0

      countries = Country.all(:order => :name)

      countries.first.name.should == "AFGHANISTAN"
    end
    
    it "should create US states" do
      UsState.count.should == 0
      @reader.process_us_states
      UsState.count.should_not == 0

      us_states = UsState.all(:order => :name)

      us_states.first.name.should == "ALASKA"
      us_states.first.abbreviation.should == "AK"
    end
    
    it "should create specialties" do
      Specialty.count.should == 0
      @reader.process_specialties
      Specialty.count.should_not == 0
      
      specialties = Specialty.all(:order => :code)

      specialties.first.code.should == "1000"
      specialties.first.name.should == "Predominantly Non"
    end
    
    it "should create degree types" do
      DegreeTypeOne.count.should == 0
      @reader.process_degree_type_ones
      DegreeTypeOne.count.should_not == 0
      
      degree_types = DegreeTypeOne.all(:order => :abbreviation)

      degree_types.first.abbreviation.should == "MS CTS"
      degree_types.first.name.should == "MS in Clinical and Translational Science (or equivalent depending on institution)"

      DegreeTypeTwo.count.should == 0
      @reader.process_degree_type_twos
      DegreeTypeTwo.count.should_not == 0
      
      degree_types = DegreeTypeTwo.all(:order => :abbreviation)
      
      degree_types.first.abbreviation.should == "DDS"
      degree_types.first.name.should == "DDS is Doctor of Dental Surgery"
    end
    
    it "should not re-create records" do
      Country.count.should == 0
      @reader.process_countries
      Country.count.should == 1
      @reader.process_countries
      Country.count.should == 1

      Specialty.count.should == 0
      @reader.process_specialties
      Specialty.count.should == 1
      @reader.process_specialties
      Specialty.count.should == 1
    end
    
    it "should create ethnic types" do
      EthnicType.count.should == 0
      @reader.process_ethnic_types
      EthnicType.count.should_not == 0
      
      types = EthnicType.all(:order => :name)
      types.first.name.should == "Hispanic Or Latino"
    end
    
    it "should create race types" do
      RaceType.count.should == 0
      @reader.process_race_types
      RaceType.count.should_not == 0
      
      types = RaceType.all(:order => :name)

      types.first.name.should == "American Indian or Alaska Native"
    end
  end

  context "outputting data" do

    it "should list activity codes" do
      @reader.output_activity_code_list
    end
    
    it "should list non phs organizations" do
      @reader.output_non_phs_organization_list
    end
    
    it "should list phs organizations" do
      @reader.output_phs_organization_list
    end
    
    it "should list countries" do
      @reader.output_country_list
    end
    
    it "should list us_states" do
      @reader.output_us_state_codes
    end
    
    it "should list specialties" do
      @reader.output_specialty_list
    end
    
    it "should list degree type ones" do
      @reader.output_degree_type_one_list
    end
    
    it "should list degree type twos" do
      @reader.output_degree_type_two_list
    end

    it "should list ethnic types" do
      @reader.output_ethnic_types
    end
    
    it "should list race types" do
      @reader.output_race_types
    end

  end
  
end