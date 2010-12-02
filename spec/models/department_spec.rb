# == Schema Information
# Schema version: 20101202161044
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
#  created_by  :string(255)
#  updated_by  :string(255)
#

require 'spec_helper'

describe Department do
  it "should create a new instance given valid attributes" do
    Factory(:department)
  end
end
