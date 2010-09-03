# == Schema Information
# Schema version: 20100903173011
#
# Table name: ctsa_reports
#
#  id             :integer         not null, primary key
#  created_by_id  :integer
#  finalized      :boolean
#  has_errors     :boolean
#  reporting_year :integer
#  grant_number   :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

require 'spec_helper'

describe CtsaReport do

  it "should create a new instance given valid attributes" do
    rpt = Factory(:ctsa_report)
    rpt.should be_valid
  end
  
  it { should belong_to(:created_by) }
  it { should have_many(:attachments) }
  
  context "associating xml file with ctsa_report" do
    
    it "should build the xml and add as attachment to the report" do
      rpt = Factory(:ctsa_report)
      rpt.attachments.should be_empty
      
      rpt.create_xml_report("#{Rails.root}/tmp/ctsa_reports/")
      
      rpt = CtsaReport.find(rpt.id)
      rpt.attachments.should_not be_empty
      rpt.attachments.first.name.should == "ctsa_report.xml"
      rpt.attachments.first.reporting_year.should == rpt.reporting_year
    end
    
  end
  
end
