# == Schema Information
# Schema version: 20100726162256
#
# Table name: publications
#
#  id               :integer         not null, primary key
#  pmcid            :string(255)
#  pmid             :string(255)
#  nihms_number     :string(255)
#  publication_date :date
#  person_id        :integer
#  abstract         :text
#  title            :string(1000)
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

describe Publication do
  it "should create a new instance given valid attributes" do
    Factory(:publication)
  end
  
  it { should belong_to(:person) }
end
