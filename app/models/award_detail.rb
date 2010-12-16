# == Schema Information
# Schema version: 20101216175350
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
#  created_by                             :string(255)
#  updated_by                             :string(255)
#

class AwardDetail < ActiveRecord::Base
  include VersionExportable
  
  has_paper_trail
  
  belongs_to :award
  
  validates_presence_of :budget_number
  
  def award_begin_date=(dt)
    self.budget_period_start_date = dt
  end
  
  def award_end_date=(dt)
    self.budget_period_end_date = dt
  end
  
  def formatted_budget_period_start_date
    self.budget_period_start_date.strftime("%m/%d/%Y") unless self.budget_period_start_date.nil?
  end
  
  def formatted_budget_period_start_date=(dt)
    self.budget_period_start_date = dt
  end

  def formatted_budget_period_end_date
    self.budget_period_end_date.strftime("%m/%d/%Y") unless self.budget_period_end_date.nil?
  end
  
  def formatted_budget_period_end_date=(dt)
    self.budget_period_end_date = dt
  end
  
end
