require 'spec_helper'
require 'timecop'

describe ApplicationController do

  context "current ctsa reporting year" do

    it "should be the current year for most of the year" do
      new_time = Time.local(2010, 12, 14, 12, 0, 0)
      Timecop.freeze(new_time)
      controller.current_ctsa_reporting_year.should == 2010
    end
    
    it "should be the previous year for the month of January" do
      new_time = Time.local(2011, 1, 20, 12, 0, 0)
      Timecop.freeze(new_time)
      controller.current_ctsa_reporting_year.should == 2010
    end
  
  end

  after(:all) do
    Timecop.return
  end

end