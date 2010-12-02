# == Schema Information
# Schema version: 20101202161044
#
# Table name: race_types
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  created_by :string(255)
#  updated_by :string(255)
#

require 'spec_helper'

describe RaceType do
  it "should create a new instance given valid attributes" do
    rt = Factory(:race_type)
    rt.to_s.should equal(rt.name)    
  end
end
