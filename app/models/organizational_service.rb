# == Schema Information
# Schema version: 20100727181206
#
# Table name: organizational_services
#
#  id                     :integer         not null, primary key
#  service_line_id        :integer
#  organizational_unit_id :integer
#  created_at             :datetime
#  updated_at             :datetime
#

class OrganizationalService < ActiveRecord::Base
  belongs_to :organizational_unit
  belongs_to :service_line
end
