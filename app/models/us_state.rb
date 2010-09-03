# == Schema Information
# Schema version: 20100903173011
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
end
