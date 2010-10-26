# == Schema Information
# Schema version: 20101026151305
#
# Table name: departments
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  externalid  :integer
#  entity_name :string(255)
#  school      :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Department < ActiveRecord::Base
end
