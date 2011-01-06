require File.dirname(__FILE__) + '/../spec_helper'

describe String do

  it "should calculate the levenshtein distance between two strings" do
    "principal investigator".levenshtein_distance("principle investigator").should == 2    
  end

end