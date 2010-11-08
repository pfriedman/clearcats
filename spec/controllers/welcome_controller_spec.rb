require 'spec_helper'

describe WelcomeController do

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
    
    describe "GET upload_error_log" do
      it "should successfully render the page" do
        get :upload_error_log
        response.should be_success
      end
    end
  
  end
  
end