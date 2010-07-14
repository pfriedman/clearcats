require 'spec_helper'

describe ActivityTypesController do

  def mock_activity_type(stubs={})
    @mock_activity_type ||= mock_model(ActivityType, stubs)
  end

  context "with an authenticated user" do
    before(:each) do
      login(user_login)
    end
    
    describe "GET index" do
      it "assigns all activity_types as @activity_types" do
        ActivityType.stub(:find).with(:all).and_return([mock_activity_type])
        get :index
        assigns[:activity_types].should == [mock_activity_type]
      end
    end

    describe "GET show" do
      it "assigns the requested activity_type as @activity_type" do
        ActivityType.stub(:find).with("37").and_return(mock_activity_type)
        get :show, :id => "37"
        assigns[:activity_type].should equal(mock_activity_type)
      end
    end

    describe "GET new" do
      it "assigns a new activity_type as @activity_type" do
        ActivityType.stub(:new).and_return(mock_activity_type)
        get :new
        assigns[:activity_type].should equal(mock_activity_type)
      end
    end

    describe "GET edit" do
      it "assigns the requested activity_type as @activity_type" do
        ActivityType.stub(:find).with("37").and_return(mock_activity_type)
        get :edit, :id => "37"
        assigns[:activity_type].should equal(mock_activity_type)
      end
    end

    describe "POST create" do

      describe "with valid params" do
        it "assigns a newly created activity_type as @activity_type" do
          ActivityType.stub(:new).with({'these' => 'params'}).and_return(mock_activity_type(:save => true))
          post :create, :activity_type => {:these => 'params'}
          assigns[:activity_type].should equal(mock_activity_type)
        end

        it "redirects to the created activity_type" do
          ActivityType.stub(:new).and_return(mock_activity_type(:save => true))
          post :create, :activity_type => {}
          response.should redirect_to(activity_type_url(mock_activity_type))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved activity_type as @activity_type" do
          ActivityType.stub(:new).with({'these' => 'params'}).and_return(mock_activity_type(:save => false))
          post :create, :activity_type => {:these => 'params'}
          assigns[:activity_type].should equal(mock_activity_type)
        end

        it "re-renders the 'new' template" do
          ActivityType.stub(:new).and_return(mock_activity_type(:save => false))
          post :create, :activity_type => {}
          response.should render_template('new')
        end
      end

    end

    describe "PUT update" do

      describe "with valid params" do
        it "updates the requested activity_type" do
          ActivityType.should_receive(:find).with("37").and_return(mock_activity_type)
          mock_activity_type.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :activity_type => {:these => 'params'}
        end

        it "assigns the requested activity_type as @activity_type" do
          ActivityType.stub(:find).and_return(mock_activity_type(:update_attributes => true))
          put :update, :id => "1"
          assigns[:activity_type].should equal(mock_activity_type)
        end

        it "redirects to the activity_type" do
          ActivityType.stub(:find).and_return(mock_activity_type(:update_attributes => true))
          put :update, :id => "1"
          response.should redirect_to(activity_type_url(mock_activity_type))
        end
      end

      describe "with invalid params" do
        it "updates the requested activity_type" do
          ActivityType.should_receive(:find).with("37").and_return(mock_activity_type)
          mock_activity_type.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :activity_type => {:these => 'params'}
        end

        it "assigns the activity_type as @activity_type" do
          ActivityType.stub(:find).and_return(mock_activity_type(:update_attributes => false))
          put :update, :id => "1"
          assigns[:activity_type].should equal(mock_activity_type)
        end

        it "re-renders the 'edit' template" do
          ActivityType.stub(:find).and_return(mock_activity_type(:update_attributes => false))
          put :update, :id => "1"
          response.should render_template('edit')
        end
      end

    end

    describe "DELETE destroy" do
      it "destroys the requested activity_type" do
        ActivityType.should_receive(:find).with("37").and_return(mock_activity_type)
        mock_activity_type.should_receive(:destroy)
        delete :destroy, :id => "37"
      end

      it "redirects to the activity_types list" do
        ActivityType.stub(:find).and_return(mock_activity_type(:destroy => true))
        delete :destroy, :id => "1"
        response.should redirect_to(activity_types_url)
      end
    end
  end
end
