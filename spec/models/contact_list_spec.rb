require 'spec_helper'

describe ContactList do

  it "should create a new instance given valid attributes" do
    Factory(:contact_list)
  end
  
  it { should belong_to(:organizational_unit) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:organizational_unit) }
  it { should have_and_belong_to_many(:contacts) }
end
