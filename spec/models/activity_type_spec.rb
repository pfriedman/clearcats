# == Schema Information
# Schema version: 20100727181206
#
# Table name: activity_types
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  service_line_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe ActivityType do

  it "should override to_s to show a user friendly representation" do
    at = Factory(:activity_type)
    at.to_s.should == at.name
  end
  
  # it { should validate_presence_of(:service_line) } ON UPDATE
  
end
