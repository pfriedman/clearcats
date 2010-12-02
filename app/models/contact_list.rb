# == Schema Information
# Schema version: 20101202161044
#
# Table name: contact_lists
#
#  id                     :integer         not null, primary key
#  name                   :string(255)
#  organizational_unit_id :integer
#  created_at             :datetime
#  updated_at             :datetime
#  created_by             :string(255)
#  updated_by             :string(255)
#

class ContactList < ActiveRecord::Base
  
  belongs_to :organizational_unit
  validates_presence_of :organizational_unit
  validates_presence_of :name
  validates_uniqueness_of :name
  has_and_belongs_to_many :contacts
  
  def to_s
    name
  end

end
