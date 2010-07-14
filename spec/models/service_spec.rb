require 'spec_helper'

describe Service do
  before(:each) do
    @valid_attributes = {
      :service_line_id => 1,
      :person_id => 1,
      :state => "value for state"
    }
  end

  it "should create a new instance given valid attributes" do
    Service.create!(@valid_attributes)
  end
end
