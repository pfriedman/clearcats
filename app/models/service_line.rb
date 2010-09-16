# == Schema Information
# Schema version: 20100915163558
#
# Table name: service_lines
#
#  id                     :integer         not null, primary key
#  name                   :string(255)
#  organizational_unit_id :integer
#  created_at             :datetime
#  updated_at             :datetime
#

class ServiceLine < ActiveRecord::Base
  
  belongs_to :organizational_unit
  has_many :activity_types
  has_many :services
  
  accepts_nested_attributes_for :activity_types, :allow_destroy => true
  
  def to_s
    name
  end
end
