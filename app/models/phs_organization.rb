# == Schema Information
# Schema version: 20101108171033
#
# Table name: organizations
#
#  id         :integer         not null, primary key
#  type       :string(255)
#  code       :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class PhsOrganization < Organization
end
