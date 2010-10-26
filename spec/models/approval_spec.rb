# == Schema Information
# Schema version: 20101026151305
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

require 'spec_helper'

describe Approval do

  it "should create a new instance given valid attributes" do
    Factory(:approval)
  end

  Approval::TYPES.each do |typ|
    it { should allow_value(typ).for(:approval_type) }
  end

  it { should_not allow_value("asdf").for(:approval_type) }
  it { should belong_to(:person) }

end
