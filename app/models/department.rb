# == Schema Information
# Schema version: 20101216175350
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
#  created_by  :string(255)
#  updated_by  :string(255)
#

class Department < ActiveRecord::Base
end
