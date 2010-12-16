# == Schema Information
# Schema version: 20101216175350
#
# Table name: institution_positions
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  created_by :string(255)
#  updated_by :string(255)
#

class InstitutionPosition < ActiveRecord::Base
  
  has_and_belongs_to_many :people
  
  def to_s
    name
  end
end
