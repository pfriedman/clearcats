# == Schema Information
# Schema version: 20100727181206
#
# Table name: services
#
#  id              :integer         not null, primary key
#  service_line_id :integer
#  person_id       :integer
#  created_by_id   :integer
#  entered_on      :date
#  state           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe Service do

  it "should create a new instance given valid attributes" do
    Factory(:service)
  end
  
  it "should start in the new state" do
    svc = Factory(:service, :person => nil, :service_line => nil)
    svc.should be_new
  end
  
  it { should belong_to(:created_by) }

end
