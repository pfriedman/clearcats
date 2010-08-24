require 'spec_helper'

describe AwardsController do

  def mock_award(stubs={})
    @mock_award ||= mock_model(Award, stubs)
  end
  
  context "with an authenticated user" do
    before(:each) do
      login(user_login)
    end

    describe "GET index" do
      
      it "should redirect to the people index page if no person identified" do
        get :index
        response.should redirect_to people_path
      end
      
      it "assigns all awards for the requested person as @awards" do
        person = mock_model(Person, :employeeid => "100176")
        FacultyWebService.stub!(:make_request).and_return(awards_response)
        Person.should_receive(:find).with(person.id.to_s).and_return(person)
        Person.stub!(:find_by_employeeid).and_return(person)
        get :index, :person_id => person.id
        assigns[:awards].should_not be_empty
      end
      
    end

    describe "GET new" do
      it "assigns a new award as @award" do
        Service.should_receive(:find).with("99").and_return(mock_model(Service, :person => mock_model(Person)))
        Award.stub(:new).and_return(mock_award)
        get :new, :service_id => "99"
        assigns[:award].should equal(mock_award)
      end
    end

    describe "GET edit" do
      it "assigns the requested award as @award" do
        Service.should_receive(:find).with("99").and_return(mock_model(Service, :person => mock_model(Person)))
        Award.stub(:find).with("37").and_return(mock_award)
        get :edit, :id => "37", :service_id => "99"
        assigns[:award].should equal(mock_award)
      end
    end

    describe "POST create" do

      describe "with valid params" do
        it "assigns a newly created award as @award" do
          Service.should_receive(:find).with("99").and_return(mock_model(Service, :person => mock_model(Person)))
          Award.stub(:new).with({'these' => 'params'}).and_return(mock_award(:save => true))
          post :create, :award => {:these => 'params'}, :service_id => "99"
          assigns[:award].should equal(mock_award)
        end

        # it "redirects to the created award" do
        #   Service.should_receive(:find).with("99").and_return(mock_model(Service, :person => mock_model(Person)))
        #   Award.stub(:new).and_return(mock_award(:save => true))
        #   post :create, :award => {}, :service_id => "99"
        #   response.should redirect_to(edit_award_url(mock_award))
        # end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved award as @award" do
          Service.should_receive(:find).with("99").and_return(mock_model(Service, :person => mock_model(Person)))
          Award.stub(:new).with({'these' => 'params'}).and_return(mock_award(:save => false))
          post :create, :award => {:these => 'params'}, :service_id => "99"
          assigns[:award].should equal(mock_award)
        end

        it "re-renders the 'new' template" do
          Service.should_receive(:find).with("99").and_return(mock_model(Service, :person => mock_model(Person)))
          Award.stub(:new).and_return(mock_award(:save => false))
          post :create, :award => {}, :service_id => "99"
          response.should render_template('new')
        end
      end

    end

    describe "PUT update" do

      describe "with valid params" do
        it "updates the requested award" do
          Service.should_receive(:find).with("99").and_return(mock_model(Service, :person => mock_model(Person)))
          Award.should_receive(:find).with("37").and_return(mock_award)
          mock_award.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :award => {:these => 'params'}, :service_id => "99"
        end

        # it "assigns the requested award as @award" do
        #   Service.should_receive(:find).with("99").and_return(mock_model(Service, :person => mock_model(Person)))
        #   Award.stub(:find).and_return(mock_award(:update_attributes => true))
        #   put :update, :id => "1", :service_id => "99"
        #   assigns[:award].should equal(mock_award)
        # end

        # it "redirects to the award" do
        #   Service.should_receive(:find).with("99").and_return(mock_model(Service, :person => mock_model(Person)))
        #   Award.stub(:find).and_return(mock_award(:update_attributes => true))
        #   put :update, :id => "1", :service_id => "99"
        #   response.should redirect_to(edit_award_url(mock_award))
        # end
      end

      describe "with invalid params" do
        it "updates the requested award" do
          Service.should_receive(:find).with("99").and_return(mock_model(Service, :person => mock_model(Person)))
          Award.should_receive(:find).with("37").and_return(mock_award)
          mock_award.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :award => {:these => 'params'}, :service_id => "99"
        end

        it "assigns the award as @award" do
          Service.should_receive(:find).with("99").and_return(mock_model(Service, :person => mock_model(Person)))
          Award.stub(:find).and_return(mock_award(:update_attributes => false))
          put :update, :id => "1", :service_id => "99"
          assigns[:award].should equal(mock_award)
        end

        it "re-renders the 'edit' template" do
          Service.should_receive(:find).with("99").and_return(mock_model(Service, :person => mock_model(Person)))
          Award.stub(:find).and_return(mock_award(:update_attributes => false))
          put :update, :id => "1", :service_id => "99"
          response.should render_template('edit')
        end
      end

    end

  end
end

def awards_response
  body = '[{"orig_sponsor_code_l3":"BECKCOU","award_end_date":"Sun Jul 24 00:00:00 -0500 2011","sponsor_name_l3":"Beckman Coulter Inc.","sponsor_code_l3":"BECKCOU","award_status":"Active-Award","proposal_status":"Awarded QA Check Complete","nu_employee_id":"1000176","total_amount":"0.30001E5","inst_num":"SP0004293","indirect_amount":"0.6191E4","restricted_budget_amount":"0.0","project_begin_date":"Thu Jul 24 00:00:00 -0500 2008","orig_sponsor_name_l3":"Beckman Coulter Inc.","proposal_title":"External Evaluation of Immunphenotyping Reagents","project_end_date":"Sun Jul 24 00:00:00 -0500 2011","direct_amount":"0.2381E5","proposal_flag":"P","parent_inst_num":"SP0004293","modified_date":"Fri Sep 04 14:15:00 -0500 2009","moved_to_projects":null,"load_date":"Thu May 20 20:03:03 -0500 2010","cufs_fund":null,"budget_number":"NORTHWESTU0000015776300020001","last_name":"Goolsby","cufs_org":null,"cufs_area":null,"award_begin_date":"Thu Jul 24 00:00:00 -0500 2008","sponsor_type_desc_l1":"Industry and Trade Organizations","department":"Pathology","budget_period":"1","sponsor_award_number":"Agmt 05/20/09","sponsor_type_l1":"INDUS","sponsor_name_l1":"Beckman Coulter Inc.","sponsor_code_l1":"BECKCOU","sponsor_name_l2":"Beckman Coulter Inc.","sponsor_code_l2":"BECKCOU","middle_name":null,"first_name":"Charles Lewis"},{"orig_sponsor_code_l3":"BECKCOU","award_end_date":"Sun Jul 24 00:00:00 -0500 2011","sponsor_name_l3":"Beckman Coulter Inc.","sponsor_code_l3":"BECKCOU","award_status":"Active-Award","proposal_status":"Awarded QA Check Complete","nu_employee_id":"1000176","total_amount":"0.38674E5","inst_num":"SP0004293","indirect_amount":"0.7568E4","restricted_budget_amount":"0.0","project_begin_date":"Thu Jul 24 00:00:00 -0500 2008","orig_sponsor_name_l3":"Beckman Coulter Inc.","proposal_title":"External Evaluation of Immunphenotyping Reagents","project_end_date":"Sun Jul 24 00:00:00 -0500 2011","direct_amount":"0.31106E5","proposal_flag":"P","parent_inst_num":"SP0004293","modified_date":"Fri Sep 04 14:15:00 -0500 2009","moved_to_projects":null,"load_date":"Thu May 20 20:03:03 -0500 2010","cufs_fund":null,"budget_number":"NORTHWESTU0000015776300010001","last_name":"Goolsby","cufs_org":null,"cufs_area":null,"award_begin_date":"Thu Jul 24 00:00:00 -0500 2008","sponsor_type_desc_l1":"Industry and Trade Organizations","department":"Pathology","budget_period":"1","sponsor_award_number":"Agmt 07/24/08","sponsor_type_l1":"INDUS","sponsor_name_l1":"Beckman Coulter Inc.","sponsor_code_l1":"BECKCOU","sponsor_name_l2":"Beckman Coulter Inc.","sponsor_code_l2":"BECKCOU","middle_name":null,"first_name":"Charles Lewis"}]'
  resp = mock_model(Net::HTTPOK, :body => body)
  return resp
end