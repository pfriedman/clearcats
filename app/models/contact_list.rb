# == Schema Information
# Schema version: 20101201173251
#
# Table name: contact_lists
#
#  id                     :integer         not null, primary key
#  name                   :string(255)
#  organizational_unit_id :integer
#  created_at             :datetime
#  updated_at             :datetime
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
