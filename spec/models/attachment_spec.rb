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

require 'spec_helper'

describe Attachment do

  it { should have_attached_file(:data) }
  it { should validate_attachment_presence(:data) }
    
end
