# == Schema Information
# Schema version: 20101202161044
#
# Table name: institution_positions
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  created_by :string(255)
#  updated_by :string(255)
#

require 'spec_helper'

describe InstitutionPosition do

  it "should override to_s to show a user friendly representation" do
    p = Factory(:institution_position, :name => "The Position")
    p.to_s.should == "The Position"
  end

  it { should have_and_belong_to_many(:people) }
  
end
