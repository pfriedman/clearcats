require 'spec_helper'

describe ApplicationHelper do

  it "is included in the helper object" do
    included_modules = (class << helper; self; end).send :included_modules
    included_modules.should include(ApplicationHelper)
  end

  it "should return the current application version" do
    helper.application_version.should == "0.0.0"
  end
  
  it "should set the @show_title attribute to true by default" do
    helper.title("page_title")
    helper.show_title?.should be_true
  end
  
  it "should return the current ctsa year" do
    helper.current_ctsa_reporting_year.should == Date.today.year
  end
  
  it "should return the default value for a blank obj" do
    helper.null_safe(nil, "asdf").should == "asdf"
  end
  
  it "should return the string value for an obj" do
    helper.null_safe("str").should == "str"
  end

end