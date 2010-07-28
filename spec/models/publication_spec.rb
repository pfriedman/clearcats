# == Schema Information
# Schema version: 20100727181206
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
#  nucats_assisted  :boolean
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

describe Publication do
  it "should create a new instance given valid attributes" do
    Factory(:publication)
  end
  
  it "should alias the older pmid (pubmed id) as pubmed" do
    pub = Factory(:publication)
    pub.pubmed.should == pub.pmid
  end
  
  it { should belong_to(:person) }
end
