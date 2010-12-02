# == Schema Information
# Schema version: 20101202161044
#
# Table name: us_states
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  abbreviation :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  created_by   :string(255)
#  updated_by   :string(255)
#

require 'spec_helper'

describe UsState do
  it "should create a new instance given valid attributes" do
    Factory(:us_state)
  end

  it "should return abbreviation as to_s" do
    s = Factory(:us_state)
    s.to_s.should == s.abbreviation
  end

  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:abbreviation) }
end
