require 'spec_helper'

describe OrganizationalUnitsController do

  def mock_organizational_unit(stubs={})
    @mock_organizational_unit ||= mock_model(OrganizationalUnit, stubs)
  end
  
  context "with an authenticated user for a particular organizational unit" do
    
    before(:each) do
      login(admin_login)
      @admin = Factory(:person, :netid => 'admin')
      @org_unit1 = Factory(:organizational_unit, :name => "org_unit1")
      @admin.organizational_units << @org_unit1
      
      @org_unit2 = Factory(:organizational_unit, :name => "org_unit2")
    end
    
    it "should /not/ allow the user to edit an org unit to which the user is not a member" do
      controller.should_receive(:determine_org_units_for_user).and_return([@org_unit1])
      OrganizationalUnit.stub(:find).with("37").and_return(@org_unit2)
      get :edit, :id => "37"
      assigns[:user_organizational_units].should == [@org_unit1]
      response.should redirect_to(organizational_unit_path(@org_unit2))
      flash[:warning].should == "You do not have access to edit #{@org_unit2}"
    end
    
    it "should allow the user to edit the org unit if a member" do
      controller.should_receive(:determine_org_units_for_user).and_return([@org_unit1])
      OrganizationalUnit.stub(:find).with("37").and_return(@org_unit1)
      get :edit, :id => "37"
      response.should be_success
    end
    
  end
  
  context "with an authenticated user" do
    before(:each) do
      login(admin_login)
    end

    describe "GET index" do
      it "assigns all organizational_units as @organizational_units" do
        OrganizationalUnit.stub(:search).and_return([mock_organizational_unit])
        get :index
        assigns[:organizational_units].should == [mock_organizational_unit]
      end
    end

    describe "GET show" do
      it "assigns the requested organizational_unit as @organizational_unit" do
        controller.should_receive(:determine_org_units_for_user).and_return([mock_organizational_unit])
        OrganizationalUnit.stub(:find).with("37").and_return(mock_organizational_unit)
        get :show, :id => "37"
        assigns[:organizational_unit].should equal(mock_organizational_unit)
      end
    end

    describe "GET new" do
      it "assigns a new organizational_unit as @organizational_unit" do
        OrganizationalUnit.stub(:new).and_return(mock_organizational_unit)
        get :new
        assigns[:organizational_unit].should equal(mock_organizational_unit)
      end
    end

    describe "GET edit" do
      it "assigns the requested organizational_unit as @organizational_unit" do
        controller.should_receive(:determine_org_units_for_user).and_return([mock_organizational_unit])
        OrganizationalUnit.stub(:find).with("37").and_return(mock_organizational_unit)
        get :edit, :id => "37"
        assigns[:organizational_unit].should equal(mock_organizational_unit)
      end
    end

    describe "POST create" do

      describe "with valid params" do
        it "assigns a newly created organizational_unit as @organizational_unit" do
          OrganizationalUnit.stub(:new).with({'these' => 'params'}).and_return(mock_organizational_unit(:save => true))
          post :create, :organizational_unit => {:these => 'params'}
          assigns[:organizational_unit].should equal(mock_organizational_unit)
        end

        it "redirects to the created organizational_unit" do
          OrganizationalUnit.stub(:new).and_return(mock_organizational_unit(:save => true))
          post :create, :organizational_unit => {}
          response.should redirect_to(organizational_units_url)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved organizational_unit as @organizational_unit" do
          OrganizationalUnit.stub(:new).with({'these' => 'params'}).and_return(mock_organizational_unit(:save => false))
          post :create, :organizational_unit => {:these => 'params'}
          assigns[:organizational_unit].should equal(mock_organizational_unit)
        end

        it "re-renders the 'new' template" do
          OrganizationalUnit.stub(:new).and_return(mock_organizational_unit(:save => false))
          post :create, :organizational_unit => {}
          response.should render_template('new')
        end
      end

    end

    describe "PUT update" do

      describe "with valid params" do
        it "updates the requested organizational_unit" do
          OrganizationalUnit.should_receive(:find).with("37").and_return(mock_organizational_unit)
          mock_organizational_unit.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :organizational_unit => {:these => 'params'}
        end

        it "assigns the requested organizational_unit as @organizational_unit" do
          OrganizationalUnit.stub(:find).and_return(mock_organizational_unit(:update_attributes => true))
          put :update, :id => "1"
          assigns[:organizational_unit].should equal(mock_organizational_unit)
        end

        it "redirects to the organizational_unit" do
          OrganizationalUnit.stub(:find).and_return(mock_organizational_unit(:update_attributes => true))
          put :update, :id => "1"
          response.should redirect_to(organizational_units_url)
        end
      end

      describe "with invalid params" do
        it "updates the requested organizational_unit" do
          OrganizationalUnit.should_receive(:find).with("37").and_return(mock_organizational_unit)
          mock_organizational_unit.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :organizational_unit => {:these => 'params'}
        end

        it "assigns the organizational_unit as @organizational_unit" do
          OrganizationalUnit.stub(:find).and_return(mock_organizational_unit(:update_attributes => false))
          put :update, :id => "1"
          assigns[:organizational_unit].should equal(mock_organizational_unit)
        end

        it "re-renders the 'edit' template" do
          OrganizationalUnit.stub(:find).and_return(mock_organizational_unit(:update_attributes => false))
          put :update, :id => "1"
          response.should render_template('edit')
        end
      end

    end

    describe "DELETE destroy" do
      it "destroys the requested organizational_unit" do
        OrganizationalUnit.should_receive(:find).with("37").and_return(mock_organizational_unit)
        mock_organizational_unit.should_receive(:destroy)
        delete :destroy, :id => "37"
      end

      it "redirects to the organizational_units list" do
        OrganizationalUnit.stub(:find).and_return(mock_organizational_unit(:destroy => true))
        delete :destroy, :id => "1"
        response.should redirect_to(organizational_units_url)
      end
    end
  end
end
