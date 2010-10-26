# == Schema Information
# Schema version: 20101026151305
#
# Table name: countries
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Country < ActiveRecord::Base
  validates_presence_of :name
  
  def to_s
    name
  end
end
