require 'spec_helper'

describe ApplicationController do


  it "should determine the current ctsa reporting year" do
    controller.current_ctsa_reporting_year.should == Date.today.year
  end

end