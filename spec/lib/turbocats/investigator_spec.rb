require 'spec_helper'

describe Turbocats::Investigator do
  
  it "should connect to the legacy database" do
    tci = Turbocats::Investigator.first
    tci.should_not be_nil
    tci.to_s.should == "[169] Contractor, Noshir"
  end
  
  it "should create a Person model from the legacy data" do
    tci = Turbocats::Investigator.first
    person = tci.to_model
    person.should_not be_nil
    person.first_name.should == "Noshir"
  end
  
end