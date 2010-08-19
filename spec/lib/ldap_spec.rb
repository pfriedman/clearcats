require 'spec_helper'

describe Ldap do

  it "should retrieve an ldap entry by unique id (netid)" do
    entry = Ldap.new.retrieve_entry("pfr957")
    entry.should_not be_nil    
    entry.title.should == "Systems Analyst/Programmer Senior"
    entry.uid.should   == "pfr957"
    entry.ou.should_not be_nil
    entry.dn.should_not be_nil
    entry.cn.should_not be_nil
    entry.givenname.should_not be_nil
    entry.displayname.should_not be_nil
    entry.mail.should_not be_nil
    entry.sn.should_not be_nil
    entry.postaladdress.should_not be_nil
    # ensure values are nil instead of throwing an error (method missing)
    entry.telephonenumber.should be_nil
    entry.facsimiletelephonenumber.should be_nil
  end

end