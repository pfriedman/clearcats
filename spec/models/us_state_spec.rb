# == Schema Information
# Schema version: 20100903173011
#
# Table name: us_states
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  abbreviation :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe UsState do
  it "should create a new instance given valid attributes" do
    Factory(:us_state)
  end
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:abbreviation) }
end
