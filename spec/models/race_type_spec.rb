# == Schema Information
# Schema version: 20101201173251
#
# Table name: race_types
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe RaceType do
  it "should create a new instance given valid attributes" do
    rt = Factory(:race_type)
    rt.to_s.should equal(rt.name)    
  end
end
