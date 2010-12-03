# == Schema Information
# Schema version: 20101202161044
#
# Table name: attachments
#
#  id                :integer         not null, primary key
#  name              :string(255)
#  reporting_year    :integer
#  attachable_id     :integer
#  attachable_type   :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  data_file_name    :string(255)
#  data_content_type :string(255)
#  data_file_size    :integer
#  data_updated_at   :datetime
#  created_by        :string(255)
#  updated_by        :string(255)
#

class Attachment < ActiveRecord::Base
  
  CTSA_ATTACHMENTS = ["Highlights_Milestones_Challenges_Attachment", "Report_Self_Evaluation_Attachment",
                      "External_Advisory_Committee_Report_Attachment", "Report_CTSA_Components_Attachment",
                      "IRB_Approval_Report_Attachment", "Career_Dev_Ind_Progress_Report_Attachment", 
                      "Technology_Transfer_Report_Attachment", "ctsa_report.xml", "ctsa_annual_report.pdf"]
  
  belongs_to :attachable, :polymorphic => true
  
  has_attached_file :data
  validates_attachment_presence :data
  
end
