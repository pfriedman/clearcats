# == Schema Information
# Schema version: 20101202161044
#
# Table name: service_lines
#
#  id                     :integer         not null, primary key
#  name                   :string(255)
#  organizational_unit_id :integer
#  created_at             :datetime
#  updated_at             :datetime
#  created_by             :string(255)
#  updated_by             :string(255)
#

require 'spec_helper'

describe ServiceLine do

  it "should override to_s to show a user friendly representation" do
    line = Factory(:service_line)
    line.to_s.should == line.name
  end
  
  it { should belong_to(:organizational_unit) }
  it { should have_many(:services) }
  it { should validate_presence_of(:name) }
  
end
