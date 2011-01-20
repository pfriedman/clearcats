require 'spec_helper'

describe SpecialtiesController do
  
  context "logged in as administrator" do

    before(:each) do
      login(admin_login)
    end
  
    describe "GET index" do
      it "should render the index page" do
        get :index
        response.should be_success
      end

      it "assigns all specialties as @specialties" do
        s = mock_model(Specialty, :to_s => "q")
        specialties = [s]
        Specialty.should_receive(:find).with(:all, {:conditions=>["lower(name) like ? or code like ?", "%q%", "%q%"]}).and_return(specialties)
        get :index, :term => "q"
        assigns[:specialties].should == [{:value=>"q", :label=>"q", :id=>s.id}]
      end
    end
  end  
end