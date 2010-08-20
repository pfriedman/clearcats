require 'spec_helper'

describe CtsaReport do

  it "should create a new instance given valid attributes" do
    rpt = Factory(:ctsa_report)
    rpt.should be_valid
  end
  
  it { should belong_to(:created_by) }
  # it { should have_many(:attachments) }
  
end
