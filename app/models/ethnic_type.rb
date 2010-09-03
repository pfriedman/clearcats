# == Schema Information
# Schema version: 20100903173011
#
# Table name: ethnic_types
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class EthnicType < ActiveRecord::Base
  def to_s
    name
  end
end
