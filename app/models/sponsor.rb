# == Schema Information
# Schema version: 20100825194150
#
# Table name: sponsors
#
#  id                       :integer         not null, primary key
#  name                     :string(255)
#  code                     :string(255)
#  sponsor_type_description :string(255)
#  sponsor_type             :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#

class Sponsor < ActiveRecord::Base
  has_many :awards
  
  def to_s
    name
  end
  
  # attributes from faculty_web_service that are not persisted
  attr_accessor :orig_sponsor_code_l3, :orig_sponsor_name_l3
  attr_accessor :sponsor_code_l1, :sponsor_name_l1
  attr_accessor :sponsor_code_l2, :sponsor_name_l2
  
  def sponsor_name_l3=(name)
    self.name = name
  end
  
  def sponsor_code_l3=(code)
    self.code = code
  end
  
  def sponsor_type_desc_l1=(desc)
    self.sponsor_type_description = desc
  end
  
  def sponsor_type_l1=(typ)
    self.sponsor_type = typ
  end
end
