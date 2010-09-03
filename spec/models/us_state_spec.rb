require 'spec_helper'

describe UsState do
  it "should create a new instance given valid attributes" do
    Factory(:us_state)
  end
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:abbreviation) }
end
