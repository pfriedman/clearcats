# == Schema Information
# Schema version: 20100727181206
#
# Table name: degree_types
#
#  id           :integer         not null, primary key
#  type         :string(255)
#  name         :string(255)
#  abbreviation :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class DegreeType < ActiveRecord::Base
  def to_s
    name
  end
end
