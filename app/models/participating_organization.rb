# == Schema Information
# Schema version: 20100903173011
#
# Table name: participating_organizations
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  city           :string(255)
#  country_id     :integer
#  us_state_id    :integer
#  reporting_year :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class ParticipatingOrganization < ActiveRecord::Base
  belongs_to :us_state
  belongs_to :country
end
