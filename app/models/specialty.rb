# == Schema Information
# Schema version: 20100726162256
#
# Table name: specialties
#
#  id         :integer         not null, primary key
#  code       :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Specialty < ActiveRecord::Base
  def to_s
    "#{code} #{name}".strip
  end
end
