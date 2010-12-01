# == Schema Information
# Schema version: 20101108171033
#
# Table name: response_sets
#
#  id              :integer         not null, primary key
#  user_id         :integer(8)
#  survey_id       :integer(8)
#  access_code     :string(255)
#  started_at      :datetime
#  completed_at    :datetime
#  created_at      :datetime
#  updated_at      :datetime
#  person_id       :integer
#  service_line_id :integer
#

class ResponseSet < ActiveRecord::Base
  unloadable
  include Surveyor::Models::ResponseSetMethods
  
  belongs_to :service
  
end
