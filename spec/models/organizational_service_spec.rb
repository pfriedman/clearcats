# == Schema Information
# Schema version: 20100825194150
#
# Table name: organizational_services
#
#  id                     :integer         not null, primary key
#  service_line_id        :integer
#  organizational_unit_id :integer
#  created_at             :datetime
#  updated_at             :datetime
#

require 'spec_helper'

describe OrganizationalService do
  it "should create a new instance given valid attributes" do
    Factory(:organizational_service)
  end
  
  it "should be a join model between organizational unit and service line" do
    org_svc = Factory(:organizational_service)
    org_svc.service_line.should_not be_nil
    org_svc.organizational_unit.should_not be_nil
    
    org_svc.service_line.organizational_units.should_not be_empty
  end
  
  
  it { should belong_to(:service_line) }
  it { should belong_to(:organizational_unit) }
  
end
