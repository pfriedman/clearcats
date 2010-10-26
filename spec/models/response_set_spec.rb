# == Schema Information
# Schema version: 20101026151305
#
# Table name: response_sets
#
#  id              :integer         not null, primary key
#  user_id         :integer(8)
#  survey_id       :integer(8)
#  access_code     :string(255)
#  started_at      :datetime
#  completed_at    :datetime
#  created_at      :datetime
#  updated_at      :datetime
#  person_id       :integer
#  service_line_id :integer
#

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
