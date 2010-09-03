# == Schema Information
# Schema version: 20100903173011
#
# Table name: publications
#
#  id                   :integer         not null, primary key
#  pmcid                :string(255)
#  pmid                 :string(255)
#  nihms_number         :string(255)
#  publication_date     :date
#  person_id            :integer
#  abstract             :text
#  title                :string(1000)
#  nucats_assisted      :boolean
#  created_at           :datetime
#  updated_at           :datetime
#  cited                :boolean
#  missing_pmcid_reason :string(255)
#  reporting_year       :integer
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
  
  context "ctsa reporting" do
    
    before(:each) do
      @pub2009 = Factory(:publication, :reporting_year => 2009)
      @pub2010 = Factory(:publication, :reporting_year => 2010)
    end
    
    it "should retrieve items by reporting year" do
      pubs = Publication.all_for_reporting_year(2010)
      pubs.size.should  == 1
      pubs.first.should == @pub2010
    end
  end
end
