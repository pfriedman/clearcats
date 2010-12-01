# == Schema Information
# Schema version: 20101201173251
#
# Table name: service_lines
#
#  id                     :integer         not null, primary key
#  name                   :string(255)
#  organizational_unit_id :integer
#  created_at             :datetime
#  updated_at             :datetime
#

require 'spec_helper'

describe ServiceLine do

  it "should override to_s to show a user friendly representation" do
    line = Factory(:service_line)
    line.to_s.should == line.name
  end
  
  it { should belong_to(:organizational_unit) }
  it { should have_many(:services) }
  
end
