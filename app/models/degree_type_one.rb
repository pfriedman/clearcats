# == Schema Information
# Schema version: 20101026151305
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

class DegreeTypeOne < DegreeType
end
