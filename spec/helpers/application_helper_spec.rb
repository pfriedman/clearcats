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
  
  it "should encode the email for display" do
    helper.encode_email("p-friedman@northwestern.edu").should == "&#112;&#45;&#102;&#114;&#105;&#101;&#100;&#109;&#97;&#110;&#64;&#110;&#111;&#114;&#116;&#104;&#119;&#101;&#115;&#116;&#101;&#114;&#110;&#46;&#101;&#100;&#117;"
  end

end