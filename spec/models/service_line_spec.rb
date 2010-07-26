# == Schema Information
# Schema version: 20100726162256
#
# Table name: service_lines
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe ServiceLine do

  it "should override to_s to show a user friendly representation" do
    line = Factory(:service_line)
    line.to_s.should == line.name
  end
  
  it { should have_many(:organizational_services) }
  it { should have_many(:organizational_units) }
  
end
