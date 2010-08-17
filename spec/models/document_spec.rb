# == Schema Information
# Schema version: 20100817202539
#
# Table name: documents
#
#  id                :integer         not null, primary key
#  name              :string(255)
#  documentable_id   :integer
#  documentable_type :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  data_file_name    :string(255)
#  data_content_type :string(255)
#  data_file_size    :integer
#  data_updated_at   :datetime
#

require 'spec_helper'

describe Document do

  it { should have_attached_file(:data) }
  it { should validate_attachment_presence(:data) }
    
end
