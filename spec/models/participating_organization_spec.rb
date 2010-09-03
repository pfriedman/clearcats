# == Schema Information
# Schema version: 20100903173011
#
# Table name: participating_organizations
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  city           :string(255)
#  country_id     :integer
#  us_state_id    :integer
#  reporting_year :integer
#  created_at     :datetime
#  updated_at     :datetime
#

require 'spec_helper'

describe ParticipatingOrganization do
  it "should create a new instance given valid attributes" do
    Factory(:participating_organization)
  end
  
  it { should belong_to(:country) }
  it { should belong_to(:us_state) }
end
