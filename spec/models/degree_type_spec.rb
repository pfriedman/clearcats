# == Schema Information
# Schema version: 20100915163558
#
# Table name: degree_types
#
#  id           :integer         not null, primary key
#  type         :string(255)
#  name         :string(255)
#  abbreviation :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe DegreeType do
  it "should create a new instance given valid attributes" do
    dt = Factory(:degree_type_one)
    dt.to_s.should equal(dt.name)
  end
end
