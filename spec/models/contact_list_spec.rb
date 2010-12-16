# == Schema Information
# Schema version: 20101216175350
#
# Table name: contact_lists
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

describe ContactList do

  it "should create a new instance given valid attributes" do
    Factory(:contact_list)
  end
  
  it "should describe itself in a human readable format" do
    c = Factory(:contact_list)
    c.to_s.should == "#{c.name}"
  end
  
  it { should belong_to(:organizational_unit) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:organizational_unit) }
  it { should have_and_belong_to_many(:contacts) }
end
