# == Schema Information
# Schema version: 20101201173251
#
# Table name: award_details
#
#  id                                     :integer         not null, primary key
#  award_id                               :integer
#  budget_period                          :string(255)
#  budget_period_start_date               :date
#  budget_period_end_date                 :date
#  budget_period_direct_cost              :float
#  budget_period_direct_and_indirect_cost :float
#  budget_number                          :string(255)
#  direct_amount                          :float
#  indirect_amount                        :float
#  total_amount                           :float
#  created_at                             :datetime
#  updated_at                             :datetime
#

require 'spec_helper'

describe AwardDetail do

  it "should create a new instance given valid attributes" do
    Factory(:award_detail)
  end
  
  it { should belong_to(:award) }
  it { should validate_presence_of(:budget_number) }
end
