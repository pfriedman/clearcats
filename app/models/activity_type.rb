# == Schema Information
# Schema version: 20101202161044
#
# Table name: activity_types
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  service_line_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#  created_by      :string(255)
#  updated_by      :string(255)
#

class ActivityType < ActiveRecord::Base
  belongs_to :service_line
  
  validates_presence_of :service_line, :on => :update
  
  def to_s
    name
  end
  
end
