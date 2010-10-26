require 'spec_helper'

describe ReportsController do

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
      
      it "assigns the clients as @clients"
      
      it "filters the clients based on selected organizational unit"
      
      it "filters the clients based on selected organizational unit and service line"
        
    end
  
  end
  
end