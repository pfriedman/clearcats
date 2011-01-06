require 'spec_helper'

describe EnotisWebService do

  context "locating approvals" do
    it "should locate approvals for a faculty member by netid" do
      Person.stub!(:find_by_netid).and_return(Factory(:person, :netid => "pgreenld"))
      EnotisWebService.stub!(:make_request).and_return(approvals_response)
      results = EnotisWebService.approvals({:netid => "pgreenld"})
      results.should_not be_nil
      results.size.should == 3
      result = results.first
      result.class.should == Approval
      result.project_title.should == "Northwestern University Clinical and Translational Sciences Institute (Former NUIRBS #0234-009/Greenland)"
      result.approval_type.should == "IRB"
      result.tracking_number.should == "STU00017544"
    end
  end


end

def approvals_response
  body = '[{"project_role":"Principal Investigator","study_name":"Northwestern University Clinical and Translational Sciences Institute (Former NUIRBS #0234-009/Greenland)","irb_number":"STU00017544","consent_role":"Obtaining"},{"project_role":"Principle Investigator","study_name":"The Enterprise Data Warehouse","irb_number":"STU00013266","consent_role":"Obtaining"},{"project_role":"PI","study_name":"Vascular Medicine at Northwestern University (Former NUIRBS #0344-011/McDermott)","irb_number":"STU00017626","consent_role":"Obtaining"},{"project_role":"Co-Investigator","study_name":"Epidemiology of Cardiovascular Low-Risk and Healthy Aging (Former NUIRBS #0623-004/Daviglus)","irb_number":"STU00028513","consent_role":"Obtaining"},{"project_role":"Co-Investigator","study_name":"Genome-Wide Association Studies in NUgene Participants","irb_number":"STU00009016","consent_role":"Obtaining"},{"project_role":"Co-Investigator","study_name":"Adenosine Myocardial Perfusion Imaging in Patients with Peripheral Artery Disease  (Former NUIRBS #0261-011/Holly)","irb_number":"STU00009999","consent_role":"Obtaining"},{"project_role":"Co-Investigator","study_name":"BRAVO","irb_number":"STU00006366","consent_role":"Obtaining"},{"project_role":"Co-Investigator","study_name":"CV Risk Factors at Ages 25-64 & Long-Term Medicare Costs (Former NUIRBS #0623-005/Daviglus)","irb_number":"STU00012963","consent_role":"Obtaining"},{"project_role":"Co-Investigator","study_name":"CVD Risks Factors in Younger and Middle-Aged Adults (Former NUIRBS #0623-002/Daviglus)","irb_number":"STU00013027","consent_role":"Obtaining"},{"project_role":"Co-Investigator","study_name":"An Assessment of the Extent, Quality, and Utility of EMR Data for GWAS of Common Complex Diseases (Former NUIRBS# 2214-006/Kho)","irb_number":"STU00027497","consent_role":"None"},{"project_role":"Co-Investigator","study_name":"Heart Failure Evaluation in Post-Menopausal Women: (Former NUIRBS #1404-009/Lloyd-Jones)","irb_number":"STU00008873","consent_role":"None"}]'
  resp = mock_model(Net::HTTPOK, :body => body)
  return resp
end

