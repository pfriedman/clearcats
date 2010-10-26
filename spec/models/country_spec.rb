# == Schema Information
# Schema version: 20101026151305
#
# Table name: countries
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Country do

  it "should create a new instance given valid attributes" do
    Factory(:country)
  end
  
  it { should validate_presence_of(:name) }
  
  it "should override to_s to show a user friendly representation" do
    c = Factory(:country)
    c.to_s.should == c.name
  end
  
end
