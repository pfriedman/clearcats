# == Schema Information
# Schema version: 20101202161044
#
# Table name: degree_types
#
#  id           :integer         not null, primary key
#  type         :string(255)
#  name         :string(255)
#  abbreviation :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  created_by   :string(255)
#  updated_by   :string(255)
#

require 'spec_helper'

describe DegreeType do
  it "should create a new instance given valid attributes" do
    dt = Factory(:degree_type_one)
    dt.to_s.should equal(dt.abbreviation)
  end
end
