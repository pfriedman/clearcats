# == Schema Information
# Schema version: 20101026151305
#
# Table name: organizational_units
#
#  id                           :integer         not null, primary key
#  name                         :string(255)
#  abbreviation                 :string(255)
#  parent_id                    :integer
#  lft                          :integer
#  rgt                          :integer
#  created_at                   :datetime
#  updated_at                   :datetime
#  cc_pers_affiliate_identifier :string(255)
#

class OrganizationalUnit < ActiveRecord::Base
  # has_many :users
  # has_many :milestones
  # has_many :projects

  has_many :service_lines
  
  has_and_belongs_to_many :people

  # has_many :participating_organizational_units
  # has_many :intake_forms, :through => :participating_organizational_units
  
  # TODO: http://www.justinball.com/2009/01/18/heirarchies-trees-jquery-prototype-scriptaculous-and-acts_as_nested_set/
  acts_as_nested_set
  
  def to_s
    str = name
    str += " (#{abbreviation})" if abbreviation
    str.strip
  end
  
  def self.find_by_cc_pers_affiliate_ids(ids)
    result = []
    affiliates = Pers::Affiliate.find_all_by_affiliate_id(ids)
    affiliates.each { |a| result << OrganizationalUnit.find_by_cc_pers_affiliate_identifier(a.name_abbrev) }
    result.compact
  end
  
end
