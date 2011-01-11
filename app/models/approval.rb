# == Schema Information
# Schema version: 20101216175350
#
# Table name: approvals
#
#  id                        :integer         not null, primary key
#  tracking_number           :string(255)
#  institution               :string(255)
#  approval_type             :string(255)
#  project_title             :string(255)
#  approval_date             :string(255)
#  nucats_assisted           :boolean
#  principal_investigator    :string(255)
#  person_id                 :integer
#  created_at                :datetime
#  updated_at                :datetime
#  created_by                :string(255)
#  updated_by                :string(255)
#  ctsa_reporting_years_mask :integer
#

class Approval < ActiveRecord::Base
  include CtsaReportable

  TYPES = ["IRB", "IACUC", "IND", "IDE", "BLA", "NDA", "Patent", "Other", "Not Applicable"]
  
  validates_inclusion_of :approval_type, :in => Approval::TYPES

  belongs_to :person

  attr_accessor :project_role
  
  # Mapping of names for enotis web service
  
  def study_name
    self.project_title
  end
  
  def study_name=(study_name)
    self.project_title = study_name
  end
  
  def irb_number
    self.tracking_number
  end
  
  def irb_number=(irb_number)
    self.tracking_number = irb_number
  end
  
  def study_approved_date=(dt)
    self.approval_date = dt
  end
  
  def study_approved_date
    self.approval_date
  end
  
end
