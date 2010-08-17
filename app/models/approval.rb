# == Schema Information
# Schema version: 20100817202539
#
# Table name: approvals
#
#  id                     :integer         not null, primary key
#  tracking_number        :string(255)
#  institution            :string(255)
#  approval_type          :string(255)
#  project_title          :string(255)
#  approval_date          :string(255)
#  nucats_assisted        :boolean
#  principal_investigator :string(255)
#  person_id              :integer
#  created_at             :datetime
#  updated_at             :datetime
#

class Approval < ActiveRecord::Base

  TYPES = ["IRB", "IACUC", "IND", "IDE", "BLA", "NDA", "Patent", "Other", "Not Applicable"]
  
  validates_inclusion_of :approval_type, :in => Approval::TYPES

  belongs_to :person

end
