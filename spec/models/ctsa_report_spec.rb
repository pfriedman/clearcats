# == Schema Information
# Schema version: 20100820144259
#
# Table name: ctsa_reports
#
#  id             :integer         not null, primary key
#  created_by_id  :integer
#  finalized      :boolean
#  has_errors     :boolean
#  reporting_year :integer
#  grant_number   :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

require 'spec_helper'

describe CtsaReport do

  it "should create a new instance given valid attributes" do
    rpt = Factory(:ctsa_report)
    rpt.should be_valid
  end
  
  it { should belong_to(:created_by) }
  # it { should have_many(:attachments) }
  
end
