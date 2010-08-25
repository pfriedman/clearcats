# == Schema Information
# Schema version: 20100825194150
#
# Table name: institution_positions
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class InstitutionPosition < ActiveRecord::Base
  
  has_and_belongs_to_many :people
  
  def to_s
    name
  end
end
