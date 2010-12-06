require 'spec_helper'

describe FacultyWebService do
  
  context "calling the faculty web service" do
    context "locating faculty" do
      it "should locate faculty members by netid" do
        FacultyWebService.stub!(:make_request).and_return(netid_response)
        results = FacultyWebService.locate({:netid => "wakibbe"})
        results.should_not be_nil
        results.size.should == 1
        result = results.first
        result.class.should == Client
        result.first_name.should == "Warren"
        result.interests.class.should == Array
        result.interests.first.should == "Bioinformatics"
        # result.era_commons_username.should == "WAKIBBE" 
      end
    
      it "should return a single person" do
        FacultyWebService.stub!(:make_request).and_return(netid_response)
        result = FacultyWebService.locate_one({:netid => "wakibbe"})
        result.class.should == Client
        result.first_name.should == "Warren"
        result.interests.class.should == Array
        result.interests.first.should == "Bioinformatics"
      end
    
      it "should return nil if no one found" do
        FacultyWebService.stub!(:make_request).and_return([])
        result = FacultyWebService.locate_one({:netid => "bad netid"})
        result.should be_nil
      end
    
      it "should locate faculty members by last name" do
        FacultyWebService.stub!(:make_request).and_return(last_name_response)
        results = FacultyWebService.locate({:last_name => "Friedman"})
        results.should_not be_nil
        results.size.should == 6
        results.first.last_name.should == "Friedman"
      end
      
      it "should default faculty entry to not have a service rendered" do
        FacultyWebService.stub!(:make_request).and_return(last_name_response)
        results = FacultyWebService.locate({:last_name => "Friedman"})
        results.first.service_rendered.should == false
      end
    
      it "should list all faculty members" do
        FacultyWebService.stub!(:make_request).and_return(last_name_response)
        results = FacultyWebService.locate({:last_name => nil, :netid => nil})
        results.should_not be_nil
        results.size.should == 6
        results.first.last_name.should == "Friedman"
      end
    
      it "should catch any exception and return no results" do
        FacultyWebService.stub!(:make_request).and_raise(Exception.new("test web service exception"))
        results = FacultyWebService.locate({:last_name => nil, :netid => nil})
        results.should be_empty
      end
    end
    
    context "grantmakers" do
      
      it "should locate all the organizations that have given awards to NU Faculty" do
        FacultyWebService.stub!(:make_request).and_return(organizations_response)
        results = FacultyWebService.award_organizations
        results.should_not be_nil
        results.size.should == 12
        result = results.first
        result.class.should == Organization
        result.name.should == "3M Company"
      end
      
      it "should catch any exception and return no results" do
        FacultyWebService.stub!(:make_request).and_raise(Exception.new("test web service exception"))
        results = FacultyWebService.award_organizations
        results.should be_empty
      end
    end

    context "awards" do
      
      it "should locate awards for a particular nu employee" do
        FacultyWebService.stub!(:make_request).and_return(awards_response)
        results = FacultyWebService.awards_for_employee({:employeeid => "1000176"})
        results.should_not be_nil
        results.size.should == 1
        result = results.first
        result.class.should == Award
        result.budget_identifier.should == "NORTHWESTU00000157763000"
        result.sponsor.should_not be_nil
        result.sponsor.name.should == "Beckman Coulter Inc."
        award_details = result.award_details.sort { |a, b| a.budget_number <=> b.budget_number }
        award_details.size.should == 2
        award_details.first.budget_number.should == "NORTHWESTU0000015776300010001"
        award_details.last.budget_number.should  == "NORTHWESTU0000015776300020001"
      end
      
      it "should catch any exception and return no results" do
        FacultyWebService.stub!(:make_request).and_raise(Exception.new("test web service exception"))
        results = FacultyWebService.awards_for_employee({:employeeid => "1000176"})
        results.should be_empty
      end
      
    end

    context "using ldap" do
      
      it "should enter information missing from the faculty db" do
        FacultyWebService.stub!(:make_request).and_return(netid_response)
        results = FacultyWebService.locate({:netid => "wakibbe"})
        result = results.first
        result.middle_name.should == "A"
      end
      
    end

  end
end

def netid_response
  body = '{"interests":["Bioinformatics","Biomedical ontologies","Genomics","Information Systems","Medical Informatics"],"tenure":"Non-tenure eligible","joint_dv_abbr":null,"era_commons_id":"WAKIBBE","descriptions":["Dr Kibbe is the principal investigator for the Patient Study Calendar module software development project, the caBIG development project that has developed a syntactically and semantically harmonized interoperable patient study calendar using agile design practices. Dr. Kibbe is the co-PI of the NIH-funded Dictyostelium Model Organism Database dictyBase. He is a proponent of Agile software development methodologies and the Agile Unified Process Framework and the application of these to biomedical research problems. Dr. Kibbe\'s group has developed NOTIS, the clinical trial information management system used for all cancer trials at Northwestern and by the genotype/phenotype biorepository NUgene (http://www.nugene.org) as the source of identified information on participant in NUgene. In NUCATS, the Northwestern CTSA organization, Dr. Kibbe recently received ARRA funding to extend NOTIS to all disease areas at Northwestern, and release the eNOTIS project as a CTSA-sponsored open source project. He is also a key participant in building a computable research representation of clinical data, through his work with the Northwestern Medicine Enterprise Data Warehouse, the caBIG Clinical Annotations Engine (which is designed to build a computable representation of pathology reports from the Cerner and Epic EMR systems), and ontology efforts, including being a co-founder of the Disease Ontology (http:/diseaseontology.sourceforge.net) and the semantically computable BRIDG domain analysis model that is being jointly developed by members of HL7, CDISC and caBIG to represent clinical research information and the semantics necessary to conduct clinical trials."],"dv_abbr":"NUCATS","basis":"FT","category":"Research","dept_id":"420000","degree":"PhD","division":{"picture_dir":"nucats","dv_abbr":"NUCATS","dept_id":"420000","label_name":"NUCATS","center_flag":1,"dv_room_number":"11th floor","dv_location_id":"0.101E3","appoint_flag":1,"dv_phone":"312-503-1709","dv_url":"http://www.nucats.northwestern.edu/index.html","dv_name":"Northwestern University Clinical and Translational Sciences Institute (NUCATS)","dv_campus_id":"0.1E1","search_name":"NUCATS","division_id":"420010","sau_id":null,"dv_type":"Clinical"},"certifications":[],"joint":[],"rank":"Res Assoc Prof","employee_id":"1018461","division_id":"420010","netid":"wakibbe","pmids":[1657962,3100052,11825185,12613351,14681407,14681427,15114363,15306695,15582151,16277761,16299224,16307524,16314072,16381903,16610959,16820428,17090585,17342793,17443163,17452344,17540033,17634620,18178591,18314582,18467348,18974179,19478018,19594883,19964623,20063464,20180973,20865558],"demographics":{"race_ethnic":"Unknown","gender":"M","birth_date":"Thu Feb 11 00:00:00 -0600 1960","employee_id":"1018461"},"joint_dv_type":null,"last_name":"Kibbe","career_track_type":[null],"field_of_study":[],"centers":["Ctr for Genetic Medicine","NUCATS"],"secondary":["Ctr for Genetic Medicine"],"clinical_interests":[],"dv_type":"Clinical","fao_email":"wakibbe@northwestern.edu","middle_name":"A","first_name":"Warren"}'
  resp = mock_model(Net::HTTPOK, :body => body)
  return resp
end

def last_name_response
  body = '[{"tenure":"Non-tenure eligible","joint_dv_abbr":null,"era_commons_id":null,"dv_abbr":"Psychiatry","basis":"CS","category":"Regular","dept_id":"318000","degree":"PhD","rank":"Asst Prof, CL","employee_id":"1005825","division_id":"318010","netid":"jbk698","joint_dv_type":null,"last_name":"Friedman","dv_type":"Clinical","fao_email":"jufriedm@hotmail.com","middle_name":"K","first_name":"Julie"},{"tenure":"Non-tenure eligible","joint_dv_abbr":null,"era_commons_id":null,"dv_abbr":"Pediatrics","basis":"CS","category":"Regular","dept_id":"316000","degree":"MD","rank":"Instructor, CL","employee_id":"1066242","division_id":"316010","netid":"asf217","joint_dv_type":null,"last_name":"Friedman","dv_type":"Clinical","fao_email":"arie@premierpeds.com","middle_name":"S","first_name":"Arie"},{"tenure":"Non-tenure eligible","joint_dv_abbr":null,"era_commons_id":null,"dv_abbr":"Psychiatry","basis":"CS","category":"Regular","dept_id":"318000","degree":"PhD","rank":"Assoc Prof, CL","employee_id":"1006440","division_id":"318010","netid":"aff224","joint_dv_type":null,"last_name":"Friedman","dv_type":"Clinical","fao_email":"draf48@aol.com","middle_name":"F","first_name":"Alan"},{"tenure":"Non-tenure eligible","joint_dv_abbr":null,"era_commons_id":null,"dv_abbr":"Med-General Internal Med","basis":"FT","category":"Regular","dept_id":"307000","degree":"MD","rank":"Asst Prof","employee_id":"1053631","division_id":"307110","netid":"jfr285","joint_dv_type":null,"last_name":"Friedman","dv_type":"Clinical","fao_email":"jfriedman@nmff.org","middle_name":null,"first_name":"Jordana"},{"tenure":"Non-tenure eligible","joint_dv_abbr":null,"era_commons_id":null,"dv_abbr":"Psychiatry","basis":"CS","category":"Regular","dept_id":"318000","degree":"PhD","rank":"Associate, CL","employee_id":"1000456","division_id":"318010","netid":"jaf930","joint_dv_type":null,"last_name":"Friedman","dv_type":"Clinical","fao_email":"jafriedman@attglobal.net","middle_name":"A","first_name":"John"},{"tenure":"Non-tenure eligible","joint_dv_abbr":null,"era_commons_id":null,"dv_abbr":"Ob/Gyn","basis":"CS","category":"Regular","dept_id":"310000","degree":"MD","rank":"Instructor, CL","employee_id":"1048977","division_id":"310010","netid":"jlf682","joint_dv_type":null,"last_name":"Friedman","dv_type":"Clinical","fao_email":"jefriedm@nmh.org","middle_name":"L","first_name":"Jennifer"}]'
  resp = mock_model(Net::HTTPOK, :body => body)
  return resp
end

def organizations_response
  body = '[{"name":"3M Company"},{"name":"AAI Corporation"},{"name":"ACCESS Medical Group Ltd."},{"name":"ACTELION Ltd."},{"name":"ADMA Biologics Inc."},{"name":"AECOM Consult Inc."},{"name":"AGA Medical Corporation"},{"name":"AGI Dermatics Inc."},{"name":"AIDS Prevention Initiative Nigeria Ltd./Gte."},{"name":"AIDS Research Alliance - Chicago"},{"name":"ALS Society of Canada"},{"name":"ALS Therapy Alliance Inc."}]'
  resp = mock_model(Net::HTTPOK, :body => body)
  return resp
end

def awards_response
  body = '[{"orig_sponsor_code_l3":"BECKCOU","award_end_date":"Sun Jul 24 00:00:00 -0500 2011","sponsor_name_l3":"Beckman Coulter Inc.","sponsor_code_l3":"BECKCOU","award_status":"Active-Award","proposal_status":"Awarded QA Check Complete","nu_employee_id":"1000176","total_amount":"0.30001E5","inst_num":"SP0004293","indirect_amount":"0.6191E4","restricted_budget_amount":"0.0","project_begin_date":"Thu Jul 24 00:00:00 -0500 2008","orig_sponsor_name_l3":"Beckman Coulter Inc.","proposal_title":"External Evaluation of Immunphenotyping Reagents","project_end_date":"Sun Jul 24 00:00:00 -0500 2011","direct_amount":"0.2381E5","proposal_flag":"P","parent_inst_num":"SP0004293","modified_date":"Fri Sep 04 14:15:00 -0500 2009","moved_to_projects":null,"load_date":"Thu May 20 20:03:03 -0500 2010","cufs_fund":null,"budget_number":"NORTHWESTU0000015776300020001","last_name":"Goolsby","cufs_org":null,"cufs_area":null,"award_begin_date":"Thu Jul 24 00:00:00 -0500 2008","sponsor_type_desc_l1":"Industry and Trade Organizations","department":"Pathology","budget_period":"1","sponsor_award_number":"Agmt 05/20/09","sponsor_type_l1":"INDUS","sponsor_name_l1":"Beckman Coulter Inc.","sponsor_code_l1":"BECKCOU","sponsor_name_l2":"Beckman Coulter Inc.","sponsor_code_l2":"BECKCOU","middle_name":null,"first_name":"Charles Lewis"},
           {"orig_sponsor_code_l3":"BECKCOU","award_end_date":"Sun Jul 24 00:00:00 -0500 2011","sponsor_name_l3":"Beckman Coulter Inc.","sponsor_code_l3":"BECKCOU","award_status":"Active-Award","proposal_status":"Awarded QA Check Complete","nu_employee_id":"1000176","total_amount":"0.38674E5","inst_num":"SP0004293","indirect_amount":"0.7568E4","restricted_budget_amount":"0.0","project_begin_date":"Thu Jul 24 00:00:00 -0500 2008","orig_sponsor_name_l3":"Beckman Coulter Inc.","proposal_title":"External Evaluation of Immunphenotyping Reagents","project_end_date":"Sun Jul 24 00:00:00 -0500 2011","direct_amount":"0.31106E5","proposal_flag":"P","parent_inst_num":"SP0004293","modified_date":"Fri Sep 04 14:15:00 -0500 2009","moved_to_projects":null,"load_date":"Thu May 20 20:03:03 -0500 2010","cufs_fund":null,"budget_number":"NORTHWESTU0000015776300010001","last_name":"Goolsby","cufs_org":null,"cufs_area":null,"award_begin_date":"Thu Jul 24 00:00:00 -0500 2008","sponsor_type_desc_l1":"Industry and Trade Organizations","department":"Pathology","budget_period":"1","sponsor_award_number":"Agmt 07/24/08","sponsor_type_l1":"INDUS","sponsor_name_l1":"Beckman Coulter Inc.","sponsor_code_l1":"BECKCOU","sponsor_name_l2":"Beckman Coulter Inc.","sponsor_code_l2":"BECKCOU","middle_name":null,"first_name":"Charles Lewis"}]'
  resp = mock_model(Net::HTTPOK, :body => body)
  return resp
end