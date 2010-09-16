# == Schema Information
# Schema version: 20100915163558
#
# Table name: organizations
#
#  id         :integer         not null, primary key
#  type       :string(255)
#  code       :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Organization < ActiveRecord::Base
  validates_presence_of :type
  validates_presence_of :code
  validates_presence_of :name
  
  has_many :awards
  
  def to_s
    return "#{self.code} #{self.name}".strip
  end
end
