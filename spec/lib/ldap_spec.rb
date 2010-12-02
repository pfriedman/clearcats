require 'spec_helper'

describe Ldap do

  it "should retrieve an ldap entry by unique id (netid)" do
    entry = Ldap.new.retrieve_entry_by_netid("pfr957")
    entry.should_not be_nil    
    assert_entry(entry)
  end
  
  it "should retrieve an ldap entry by email" do
    entry = Ldap.new.retrieve_entry_by_email("p-friedman@northwestern.edu")
    entry.should_not be_nil    
  end

  def assert_entry(entry)
    entry["title"].to_s.should == "Systems Analyst/Programmer Senior"
    entry.uid.to_s.should   == "pfr957"
    entry.ou.to_s.should_not be_blank
    entry.dn.to_s.should_not be_blank
    entry.cn.to_s.should_not be_blank
    entry.givenname.to_s.should_not be_blank
    entry.displayname.to_s.should_not be_blank
    entry.mail.to_s.should_not be_blank
    entry.sn.to_s.should_not be_blank
    entry.postaladdress.to_s.should_not be_blank
    # ensure values are nil instead of throwing an error (method missing)
    entry.telephonenumber.to_s.should be_blank
    entry.facsimiletelephonenumber.to_s.should be_blank
  end

end