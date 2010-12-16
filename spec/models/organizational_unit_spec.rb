# == Schema Information
# Schema version: 20101216175350
#
# Table name: organizational_units
#
#  id                           :integer         not null, primary key
#  name                         :string(255)
#  abbreviation                 :string(255)
#  parent_id                    :integer
#  lft                          :integer
#  rgt                          :integer
#  created_at                   :datetime
#  updated_at                   :datetime
#  cc_pers_affiliate_identifier :string(255)
#  created_by                   :string(255)
#  updated_by                   :string(255)
#

require 'spec_helper'
require 'pers/affiliate'

describe OrganizationalUnit do
  it "should create a new instance given valid attributes" do
    ou = Factory(:organizational_unit)
    ou.to_s.should == "#{ou.name} (#{ou.abbreviation})"
  end
  
  it "should locate records from pers::affiliate abbreviations" do
    abbrev = "asdf"
    ou = Factory(:organizational_unit, :cc_pers_affiliate_identifier => abbrev)
    Pers::Affiliate.stub(:find).and_return([mock_model(Pers::Affiliate, :name_abbrev => abbrev)])
    OrganizationalUnit.find_by_cc_pers_affiliate_ids([37]).should == [ou]
  end
  
  it { should have_and_belong_to_many(:people) }
  it { should have_and_belong_to_many(:contacts) }
  
  it { should belong_to(:parent) }
  it { should have_many(:children) }
  it { should have_many(:service_lines) }
  it { should have_many(:contact_lists) }

end
