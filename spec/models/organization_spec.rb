# == Schema Information
# Schema version: 20100817202539
#
# Table name: organizations
#
#  id         :integer         not null, primary key
#  type       :string(255)
#  code       :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Organization do
  
  it { should validate_presence_of(:type) }
  it { should validate_presence_of(:code) }
  it { should validate_presence_of(:name) }
  
  it { should have_many(:awards) }
  
  it "should create non-phs organizations" do
    org = NonPhsOrganization.new
    org.type.should == "NonPhsOrganization"
  end
  
  it "should create phs organizations" do
    org = PhsOrganization.new
    org.type.should == "PhsOrganization"
  end
  
  it "should override to_s to show a user friendly representation" do
    org = PhsOrganization.new(:code => "code", :name => "name")
    org.to_s.should == "code name"
  end
end
