# == Schema Information
# Schema version: 20100820144259
#
# Table name: documents
#
#  id                :integer         not null, primary key
#  name              :string(255)
#  reporting_year    :integer
#  documentable_id   :integer
#  documentable_type :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  data_file_name    :string(255)
#  data_content_type :string(255)
#  data_file_size    :integer
#  data_updated_at   :datetime
#

class Document < ActiveRecord::Base
  
  belongs_to :documentable, :polymorphic => true
  
  has_attached_file :data
  validates_attachment_presence :data
  
end
