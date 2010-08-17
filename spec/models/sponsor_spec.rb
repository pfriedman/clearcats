# == Schema Information
# Schema version: 20100817202539
#
# Table name: sponsors
#
#  id                       :integer         not null, primary key
#  name                     :string(255)
#  code                     :string(255)
#  sponsor_type_description :string(255)
#  sponsor_type             :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#

require 'spec_helper'

describe Sponsor do

  it "should create a new instance given valid attributes" do
    Factory(:sponsor)
  end
  
  it "should override to_s to show a user friendly representation" do
    p = Factory(:sponsor, :name => "sponsor name")
    p.to_s.should == "sponsor name"
  end
  
  it { should have_many(:awards) }
  
end
