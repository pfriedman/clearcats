require 'spec_helper'

describe ApprovalsController do

  def mock_approval(stubs={})
    @mock_approval ||= mock_model(Approval, stubs)
  end
  
  def mock_person(stubs={})
    @mock_person ||= mock_model(Person, stubs)
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
      
      it "assigns all approvals for the requested person as @approvals" do
        person = mock_model(Person, :employeeid => "100176", :imported => false, :netid => "")
        Person.should_receive(:find).with(person.id.to_s).and_return(person)
        EnotisWebService.stub!(:approvals).and_return([])
        Approval.stub(:search).and_return(mock_model(Array, :all => [mock_approval]))
        get :index, :person_id => person.id
        assigns[:approvals].should_not be_empty
      end
      
    end
    
    describe "GET search" do
      it "assigns all approvals for the sent criteria as @approvals" do
        Approval.stub(:search).and_return(mock_model(Array, :paginate => [mock_approval]))
        get :search
        assigns[:approvals].should_not be_empty
      end
    end
    
    describe "POST update_approvals" do
      it "updates the requested approval" do
        mock = mock_model(Person, :employeeid => "100176", :imported => false, :netid => "")
        Person.should_receive(:find).with(mock.id.to_s).and_return(mock)
        mock.should_receive(:update_attributes).with({'approval' => 'params'})
        put :update_approvals, :person_id => mock.id.to_s, :person => {:approval => 'params'}
      end


      it "redirects to the person approvals path" do
        mock = mock_model(Person, :employeeid => "100176", :imported => false, :netid => "")
        Person.should_receive(:find).with(mock.id.to_s).and_return(mock)
        mock.should_receive(:update_attributes).with({'approval' => 'params'})
        put :update_approvals, :person_id => mock.id.to_s, :person => {:approval => 'params'}
        response.should redirect_to(person_approvals_url(mock))
      end

      
    end
    
  end
end