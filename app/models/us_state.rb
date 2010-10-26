# == Schema Information
# Schema version: 20101026151305
#
# Table name: us_states
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  abbreviation :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class UsState < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :abbreviation
  
  def to_s
    self.abbreviation
  end
end
