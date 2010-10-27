require 'spec_helper'

describe ReportsController do

  def mock_client(stubs={})
    @mock_client ||= mock_model(Client, stubs)
  end
  
  def mock_organizational_unit(stubs={})
    @mock_organizational_unit ||= mock_model(OrganizationalUnit, stubs)
  end

  context "logged in as administrator" do

    before(:each) do
      login(admin_login)
    end
  
    describe "GET index" do
      it "should successfully render the index page" do
        get :index
        response.should be_success
      end
    end
    
    describe "GET client_list" do
      it "should successfully render the page" do
        get :client_list
        response.should be_success
      end
      
      it "assigns the clients as @clients" do
        Client.stub(:search).and_return([mock_client])
        get :client_list
        assigns[:clients].should  == [mock_client]
      end
        
    end
  
  end
  
end