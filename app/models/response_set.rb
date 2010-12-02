# == Schema Information
# Schema version: 20101202161044
#
# Table name: response_sets
#
#  id           :integer         not null, primary key
#  user_id      :integer
#  survey_id    :integer
#  access_code  :string(255)
#  started_at   :datetime
#  completed_at :datetime
#  created_at   :datetime
#  updated_at   :datetime
#  service_id   :integer
#  created_by   :string(255)
#  updated_by   :string(255)
#

class ResponseSet < ActiveRecord::Base
  unloadable
  include Surveyor::Models::ResponseSetMethods
  
  belongs_to :service
  
end
