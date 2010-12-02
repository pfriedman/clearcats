# == Schema Information
# Schema version: 20101202161044
#
# Table name: publications
#
#  id                        :integer         not null, primary key
#  pmcid                     :string(255)
#  pmid                      :string(255)
#  nihms_number              :string(255)
#  publication_date          :date
#  person_id                 :integer
#  abstract                  :text
#  title                     :string(1000)
#  nucats_assisted           :boolean
#  edited_by_user            :boolean
#  created_at                :datetime
#  updated_at                :datetime
#  cited                     :boolean
#  missing_pmcid_reason      :string(255)
#  ctsa_reporting_years_mask :integer
#  created_by                :string(255)
#  updated_by                :string(255)
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
      @pub2000 = Factory(:publication, :ctsa_reporting_years_mask => 1) # 2000
      @pub2001 = Factory(:publication, :ctsa_reporting_years_mask => 2) # 2001
    end
    
    it "should retrieve items by reporting year" do
      pubs = Publication.all_for_reporting_year(2001)
      pubs.size.should  == 1
      pubs.first.should == @pub2001
    end
    
    
    it "should know if has already been reported" do
      @pub2000.previously_reported?(2001).should be_true
      
      @pub2001.previously_reported?(2001).should be_false
      @pub2001.previously_reported?(2002).should be_true
      
      new_pub = Factory(:publication, :ctsa_reporting_years_mask => nil)
      new_pub.previously_reported?(2001).should be_false
      new_pub.previously_reported?(2002).should be_false
    end
    
  end
end
