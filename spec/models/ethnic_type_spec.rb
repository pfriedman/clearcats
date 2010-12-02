# == Schema Information
# Schema version: 20101202161044
#
# Table name: ethnic_types
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  created_by :string(255)
#  updated_by :string(255)
#

require 'spec_helper'

describe EthnicType do
  it "should create a new instance given valid attributes" do
    et = Factory(:ethnic_type)
    et.to_s.should equal(et.name)
  end
end
