require 'spec_helper'

describe AdminController do

  it "should use AdminController" do
    controller.should be_an_instance_of(AdminController)
  end

  context "with an authenticated admin user" do
    before(:each) do
      login(admin_login)
    end
    
    describe "GET index" do
      it "should render the index page" do
        get :index
        response.should be_success
      end
    end
    
    describe "ctsa_upload_file" do
      
      it "should render the ctsa_upload_file page" do
        get :upload_ctsa_data
        response.should be_success
      end
      
      it "should not allow the user to GET process_ctsa_upload" do
        get :process_ctsa_upload
        flash[:warning].should == "Could not process CTSA Upload"
        response.should be_redirect
        response.should redirect_to(:controller => :admin, :action => :index)
      end
      
      it "should save the uploaded document" do
        file_name = File.expand_path(File.dirname(__FILE__) + '/../data/2010 CTSA XML Schema.xsd')
        data = mock(Object, :path => file_name)
        document = mock_model(Document, :save => true, :data => data)
        
        Document.should_receive(:new).and_return(document)
        post :process_ctsa_upload, { "id" => "1", "document" => document }
      
        flash[:notice].should == "CTSA data processed successfully"
        response.should redirect_to(:controller => :admin, :action => :view_ctsa_data)
      end
      
      it "should alert the user if the document could not be saved" do
        document = mock_model(Document, :save => false)
        
        Document.should_receive(:new).and_return(document)
        post :process_ctsa_upload
        flash[:warning].should == "Could not process CTSA Upload"
        response.should render_template('upload_ctsa_data')
      end
      
    end
    
    describe "viewing ctsa data" do
      
      it "should render the activity codes page" do
        get :activity_codes
        response.should be_success
      end
      
      it "should render the countries page" do
        get :countries
        response.should be_success
      end
      
      it "should render the phs_organizations page" do
        get :phs_organizations
        response.should be_success
      end
      
      it "should render the non_phs_organizations page" do
        get :non_phs_organizations
        response.should be_success
      end
      
      it "should render the specialties page" do
        get :specialties
        response.should be_success
      end
      
      it "should render the degree type ones page" do
        get :degree_type_ones
        response.should be_success
      end
      
      it "should render the degree type twos page" do
        get :degree_type_twos
        response.should be_success
      end
      
      it "should render the ethnic types page" do
        get :ethnic_types
        response.should be_success
      end
      
      it "should render the race types page" do
        get :race_types
        response.should be_success
      end
      
    end
    
  end

  context "with an authenticated user who is not an administrator" do
    before(:each) do
      login(user_login)
    end
    
    describe "GET index" do
      it "should redirect the user to the welcome page" do
        get :index
        
        response.body.should == " "
        # FIXME: configure bcsec authentication to use custom logic (e.g. redirects)
        # response.should be_redirect
        # response.should redirect_to(:controller => :welcome, :action => :index)
      end
    end
  end

end
