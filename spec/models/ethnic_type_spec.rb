# == Schema Information
# Schema version: 20100915163558
#
# Table name: ethnic_types
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe EthnicType do
  it "should create a new instance given valid attributes" do
    et = Factory(:ethnic_type)
    et.to_s.should equal(et.name)
  end
end
