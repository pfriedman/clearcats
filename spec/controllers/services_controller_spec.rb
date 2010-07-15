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
    
  end
end