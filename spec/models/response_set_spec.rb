# == Schema Information
# Schema version: 20101216175350
#
# Table name: response_sets
#
#  id           :integer         not null, primary key
#  user_id      :integer
#  survey_id    :integer
#  access_code  :string(255)
#  started_at   :datetime
#  completed_at :datetime
#  created_at   :datetime
#  updated_at   :datetime
#  service_id   :integer
#  created_by   :string(255)
#  updated_by   :string(255)
#

require 'spec_helper'

describe ResponseSet do

  it { should belong_to(:user) }
  it { should belong_to(:survey) }
  
  it { should belong_to(:service) }
  
  it "should assign survey to response set" do
    rs = ResponseSet.new
    rs.survey = Survey.new
    rs.survey.should_not be_nil
  end
  
end
