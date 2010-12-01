# == Schema Information
# Schema version: 20101201173251
#
# Table name: departments
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  externalid  :integer
#  entity_name :string(255)
#  school      :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Department do
  it "should create a new instance given valid attributes" do
    Factory(:department)
  end
end
