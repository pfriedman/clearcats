require 'spec_helper'

describe Turbocats::Investigator do
  
  it "should connect to the legacy database and return a Person object" do
    
    tci = Turbocats::Investigator.first
    tci.should_not be_nil
    
    p tci.attributes.keys.join(", ")
    p tci.attributes.values.join(", ")
    
  end
  
end