require 'spec_helper'

describe ServicesController do

  def mock_service(stubs={})
    @mock_service ||= mock_model(Service, stubs)
  end
  
  context "with an authenticated user" do
    before(:each) do
      login(user_login)
    end

    describe "GET new" do
      it "assigns a new service as @service" do
        Service.stub(:new).and_return(mock_service)
        get :new
        assigns[:service].should equal(mock_service)
      end
    end
    
    describe "GET choose_person" do
      it "assigns a new service as @service if no id given" do
        Service.stub(:new).and_return(mock_service)
        get :choose_person
        assigns[:service].should equal(mock_service)
      end
      
      it "assigns the given service as @service" do
        Service.stub(:find).with("37").and_return(mock_service)
        get :choose_person, :id => "37"
        assigns[:service].should equal(mock_service)
      end
    end
    
    describe "POST create" do

      describe "with valid params" do
        it "assigns a newly created activity_type as @activity_type" do
          Service.stub(:new).with({'these' => 'params'}).and_return(mock_service(:save! => true, :created_by= => true, :state => "new", :initiated? => true))
          post :create, :service => {:these => 'params'}
          assigns[:service].should equal(mock_service)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved activity_type as @activity_type" do
          Service.stub(:new).with({'these' => 'params'}).and_return(mock_service(:save! => false, :created_by= => true))
          post :create, :service => {:these => 'params'}
          assigns[:service].should equal(mock_service)
        end

        it "re-renders the 'new' template" do
          Service.stub(:new).and_return(mock_service(:save! => false, :created_by= => true))
          post :create, :service => {}
          response.should render_template('new')
        end
      end

    end
  end
end