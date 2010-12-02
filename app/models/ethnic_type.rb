# == Schema Information
# Schema version: 20101202161044
#
# Table name: ethnic_types
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  created_by :string(255)
#  updated_by :string(255)
#

class EthnicType < ActiveRecord::Base
  def to_s
    name
  end
end
