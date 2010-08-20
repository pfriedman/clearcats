# == Schema Information
# Schema version: 20100820144259
#
# Table name: organizational_units
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  abbreviation :string(255)
#  parent_id    :integer
#  lft          :integer
#  rgt          :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class OrganizationalUnit < ActiveRecord::Base
  # has_many :users
  # has_many :milestones
  # has_many :projects

  has_many :organizational_services
  has_many :service_lines, :through => :organizational_services

  # has_many :participating_organizational_units
  # has_many :intake_forms, :through => :participating_organizational_units
  
  # TODO: http://www.justinball.com/2009/01/18/heirarchies-trees-jquery-prototype-scriptaculous-and-acts_as_nested_set/
  acts_as_nested_set
  
  def to_s
    str = name
    str += " (#{abbreviation})" if abbreviation
    str.strip
  end
  
  # TODO: City and State for CTSA reporting
  def city
    "Chicago"
  end
  
  def us_state
    "IL"
  end
  
  def country_name
    nil
  end
  
end
