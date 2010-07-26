# == Schema Information
# Schema version: 20100726162256
#
# Table name: activity_types
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  service_line_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class ActivityType < ActiveRecord::Base
  belongs_to :service_line
  
  validates_presence_of :service_line, :on => :update
  
  def to_s
    name
  end
  
end
