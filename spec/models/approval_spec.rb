require 'spec_helper'

describe Approval do

  it "should create a new instance given valid attributes" do
    Factory(:approval)
  end

  Approval::TYPES.each do |typ|
    it { should allow_value(typ).for(:approval_type) }
  end

  it { should_not allow_value("asdf").for(:approval_type) }
  it { should belong_to(:person) }

end
