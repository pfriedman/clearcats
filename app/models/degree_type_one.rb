# == Schema Information
# Schema version: 20101202161044
#
# Table name: degree_types
#
#  id           :integer         not null, primary key
#  type         :string(255)
#  name         :string(255)
#  abbreviation :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  created_by   :string(255)
#  updated_by   :string(255)
#

class DegreeTypeOne < DegreeType
end
