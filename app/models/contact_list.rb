class ContactList < ActiveRecord::Base
  
  belongs_to :organizational_unit
  validates_presence_of :organizational_unit
  validates_presence_of :name
  has_and_belongs_to_many :contacts

end
