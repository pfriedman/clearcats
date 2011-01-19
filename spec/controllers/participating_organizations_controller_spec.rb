require 'spec_helper'

describe ParticipatingOrganizationsController do

  def mock_participating_organization(stubs={})
    @mock_participating_organization ||= mock_model(ParticipatingOrganization, stubs)
  end

  context "with an authenticated user" do
    before(:each) do
      login(user_login)
    end

    describe "GET index" do
      it "assigns all participating_organizations as @participating_organizations" do
        ParticipatingOrganization.stub(:search).and_return([mock_participating_organization])
        get :index
        assigns[:participating_organizations].should == [mock_participating_organization]
      end
    end

    describe "GET show" do
      it "assigns the requested participating_organization as @participating_organization" do
        ParticipatingOrganization.stub(:find).with("37").and_return(mock_participating_organization)
        get :show, :id => "37"
        assigns[:participating_organization].should equal(mock_participating_organization)
      end
    end

    describe "GET new" do
      it "assigns a new participating_organization as @participating_organization" do
        ParticipatingOrganization.stub(:new).and_return(mock_participating_organization)
        get :new
        assigns[:participating_organization].should equal(mock_participating_organization)
      end
    end

    describe "GET edit" do
      it "assigns the requested participating_organization as @participating_organization" do
        ParticipatingOrganization.stub(:find).with("37").and_return(mock_participating_organization)
        get :edit, :id => "37"
        assigns[:participating_organization].should equal(mock_participating_organization)
      end
    end

    describe "POST create" do

      describe "with valid params" do
        it "assigns a newly created participating_organization as @participating_organization" do
          ParticipatingOrganization.stub(:new).with({'these' => 'params'}).and_return(mock_participating_organization(:save => true))
          post :create, :participating_organization => {:these => 'params'}
          assigns[:participating_organization].should equal(mock_participating_organization)
        end

        it "redirects to the created participating_organization" do
          ParticipatingOrganization.stub(:new).and_return(mock_participating_organization(:save => true))
          post :create, :participating_organization => {}
          response.should redirect_to(edit_participating_organization_url(mock_participating_organization))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved participating_organization as @participating_organization" do
          ParticipatingOrganization.stub(:new).with({'these' => 'params'}).and_return(mock_participating_organization(:save => false))
          post :create, :participating_organization => {:these => 'params'}
          assigns[:participating_organization].should equal(mock_participating_organization)
        end

        it "re-renders the 'new' template" do
          ParticipatingOrganization.stub(:new).and_return(mock_participating_organization(:save => false))
          post :create, :participating_organization => {}
          response.should render_template('new')
        end
      end

    end

    describe "PUT update" do

      describe "with valid params" do
        it "updates the requested participating_organization" do
          ParticipatingOrganization.should_receive(:find).with("37").and_return(mock_participating_organization)
          mock_participating_organization.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :participating_organization => {:these => 'params'}
        end

        it "assigns the requested participating_organization as @participating_organization" do
          ParticipatingOrganization.stub(:find).and_return(mock_participating_organization(:update_attributes => true))
          put :update, :id => "1"
          assigns[:participating_organization].should equal(mock_participating_organization)
        end

        it "redirects to the participating_organization" do
          ParticipatingOrganization.stub(:find).and_return(mock_participating_organization(:update_attributes => true))
          put :update, :id => "1"
          response.should redirect_to(edit_participating_organization_url(mock_participating_organization))
        end
      end

      describe "with invalid params" do
        it "updates the requested participating_organization" do
          ParticipatingOrganization.should_receive(:find).with("37").and_return(mock_participating_organization)
          mock_participating_organization.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :participating_organization => {:these => 'params'}
        end

        it "assigns the participating_organization as @participating_organization" do
          ParticipatingOrganization.stub(:find).and_return(mock_participating_organization(:update_attributes => false))
          put :update, :id => "1"
          assigns[:participating_organization].should equal(mock_participating_organization)
        end

        it "re-renders the 'edit' template" do
          ParticipatingOrganization.stub(:find).and_return(mock_participating_organization(:update_attributes => false))
          put :update, :id => "1"
          response.should render_template('edit')
        end
      end

    end

    describe "DELETE destroy" do
      it "destroys the requested participating_organization" do
        ParticipatingOrganization.should_receive(:find).with("37").and_return(mock_participating_organization)
        mock_participating_organization.should_receive(:destroy)
        delete :destroy, :id => "37"
      end

      it "redirects to the participating_organizations list" do
        ParticipatingOrganization.stub(:find).and_return(mock_participating_organization(:destroy => true))
        delete :destroy, :id => "1"
        response.should redirect_to(participating_organizations_url)
      end
    end
  end
end
