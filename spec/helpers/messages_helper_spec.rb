require 'spec_helper'

describe ReportMessageHelper do

  context "CTSA Progress Report" do
    
    before(:each) do
      @grant_number  = "123456"
      @investigator  = Factory(:person, :degree_type_one => nil, :degree_type_two => nil)
      @trainee       = Factory(:person, :appointed_trainee => true, :training_type => Person::SCHOLAR)
      @investigators = [@investigator]
      @trainees      = [@trainee]
    end
    
    it "should instantiate an XML element for the CTSA APR with a root element of Progress_Report" do
      
      doc = REXML::Document.new
      doc.add_element(ReportMessageHelper.new(@grant_number, @investigators, @trainees))
      doc.write("",2)
      report = 
"<sis:Progress_Report xsi:schemaLocation='http://sis.ncrr.nih.gov http://aprsis.ncrr.nih.gov/xml/ctsa_progress_report.xsd' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:sis='http://sis.ncrr.nih.gov'>" +
  "<sis:Grant_Info><sis:Six_Digit_Grant_Number>" + @grant_number + "</sis:Six_Digit_Grant_Number></sis:Grant_Info>" +
  "<sis:Roster>"+
    "<sis:Investigator>" +
      "<sis:Commons_Username>"  + @investigator.era_commons_username.upcase + "</sis:Commons_Username>" +
      "<sis:Area_of_Expertise>" + @investigator.specialty.code + "</sis:Area_of_Expertise>" +
    "</sis:Investigator>" +
    "<sis:Training>" +
			"<sis:Scholar>" +
				"<sis:Commons_Username>" + @trainee.era_commons_username.upcase + "</sis:Commons_Username>" +
				"<sis:Degree_Sought_1>" + @trainee.degree_type_one.to_s + "</sis:Degree_Sought_1>" +
				"<sis:Degree_Sought_2>" + @trainee.degree_type_two.to_s + "</sis:Degree_Sought_2>" +
				"<sis:Area_of_Training>" + @trainee.specialty.code + "</sis:Area_of_Training>" +
				"<sis:Date_of_Appointment>" + Date.today.strftime('%Y-%m-%d') + "</sis:Date_of_Appointment>" +
				"<sis:End_Date>" + Date.today.strftime('%Y-%m-%d') + "</sis:End_Date>" +
				"<sis:Mentor_Commons_Username>" + "" + "</sis:Mentor_Commons_Username>" +
			"</sis:Scholar>" +
		"</sis:Training>" + 
  "</sis:Roster>" +
"</sis:Progress_Report>"

      doc.to_s.should == report
    end
  end
  
  
  
  
end