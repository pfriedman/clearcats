# == Schema Information
# Schema version: 20101026151305
#
# Table name: race_types
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class RaceType < ActiveRecord::Base
  def to_s
    name
  end
end
