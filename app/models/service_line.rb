# == Schema Information
# Schema version: 20100726162256
#
# Table name: service_lines
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class ServiceLine < ActiveRecord::Base
  
  has_many :organizational_services
  has_many :organizational_units, :through => :organizational_services
  has_many :activity_types
  
  accepts_nested_attributes_for :activity_types, :allow_destroy => true
  accepts_nested_attributes_for :organizational_services, :allow_destroy => true
  
  def to_s
    name
  end
end
