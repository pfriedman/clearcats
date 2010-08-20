# == Schema Information
# Schema version: 20100820144259
#
# Table name: organizational_units
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  abbreviation :string(255)
#  parent_id    :integer
#  lft          :integer
#  rgt          :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe OrganizationalUnit do
  it "should create a new instance given valid attributes" do
    ou = Factory(:organizational_unit)
    ou.to_s.should == "#{ou.name} (#{ou.abbreviation})"
  end
  
  it { should belong_to(:parent) }
  it { should have_many(:children) }
  it { should have_many(:organizational_services) }
  it { should have_many(:service_lines) }
  # it { should have_many(:users) }
  # it { should have_many(:milestones) }
  # it { should have_many(:projects) }
end
