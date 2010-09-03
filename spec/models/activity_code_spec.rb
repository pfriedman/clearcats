# == Schema Information
# Schema version: 20100903173011
#
# Table name: activity_codes
#
#  id         :integer         not null, primary key
#  code       :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe ActivityCode do
  
  it "should create a new instance given valid attributes" do
    code = Factory(:activity_code)
    code.to_s.should == "#{code.code} #{code.name}"
  end
  
  it { should validate_presence_of(:code) }
  it { should validate_presence_of(:name) }
  it { should have_many(:awards) }
  
end
