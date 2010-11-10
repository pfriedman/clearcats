# == Schema Information
# Schema version: 20101108171033
#
# Table name: activity_codes
#
#  id         :integer         not null, primary key
#  code       :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

# An ActivityCode is the CTSA name for a Federal Non-PHS Awards
# (e.g. R01 Research Project)
class ActivityCode < ActiveRecord::Base
  validates_presence_of :code
  validates_presence_of :name
  
  has_many :awards
  
  def to_s
    return "#{code} #{name}".strip
  end
  
end
