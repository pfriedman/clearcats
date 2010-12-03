require 'spec_helper'

describe DataScrubber do

  context "updating Service creators" do
    
    it "should set the created_by field for a service" do
      ou       = Factory(:organizational_unit, :abbreviation => "CECD")
      svc_line = Factory(:service_line, :organizational_unit => ou)
      svc      = Factory(:service, :service_line => svc_line)
      svc.created_by.should be_nil
      
      DataScrubber.update_service_creators
      
      svc = Service.find(svc.id)
      svc.created_by.should_not be_nil
      svc.created_by.should == "mns521"
    end
    
  end

  context "updating records with era_commons_usernames" do
    
    it "should map the users from the file provided by the Office of Sponsored Research" do
      map = DataScrubber.get_commons_name_map_from_file
      map["1001531"].should == "R-GOLDMAN"
      map["Robert David Goldman"].should == "R-GOLDMAN"
    end
    
    it "should update the user by emplid" do
      pers = Factory(:person, :employeeid => "1001005", :era_commons_username => nil)
      DataScrubber.update_records_with_era_commons_usernames
      pers = Person.find(pers.id)
      pers.era_commons_username.should == "MARIADINO"
    end
    
    it "should update the user by name" do
      pers = Factory(:person, :last_name => "Dranove", :first_name => "David", :employeeid => nil, :era_commons_username => nil)
      DataScrubber.update_records_with_era_commons_usernames
      pers = Person.find(pers.id)
      pers.era_commons_username.should == "VPDRAVID"
    end
    
    it "should not update a record that is not in the file" do
      pers = Factory(:person, :last_name => "asdf", :first_name => "sdf", :employeeid => nil, :era_commons_username => nil)
      DataScrubber.update_records_with_era_commons_usernames
      pers = Person.find(pers.id)
      pers.era_commons_username.should be_nil
    end
    
  end

end