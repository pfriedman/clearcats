require 'spec_helper'

describe ResponseSet do

  it { should belong_to(:user) }
  it { should belong_to(:survey) }
  
  it { should belong_to(:person) }
  
  it "should assign survey to response set" do
    rs = ResponseSet.new
    rs.survey = Survey.new
    rs.survey.should_not be_nil
  end
  
end