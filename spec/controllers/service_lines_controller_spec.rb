require 'spec_helper'

describe ServiceLinesController do

  def mock_service_line(stubs={})
    @mock_service_line ||= mock_model(ServiceLine, stubs)
  end
  
  context "with an authenticated user" do
    before(:each) do
      login(admin_login)
    end

    describe "GET index" do
      it "assigns all service_lines as @service_lines" do
        ServiceLine.stub(:find).with(:all).and_return([mock_service_line])
        get :index
        assigns[:service_lines].should == [mock_service_line]
      end
    end

    describe "GET show" do
      it "assigns the requested service_line as @service_line" do
        ServiceLine.stub(:find).with("37").and_return(mock_service_line)
        get :show, :id => "37"
        assigns[:service_line].should equal(mock_service_line)
      end
    end

    describe "GET new" do
      it "assigns a new service_line as @service_line" do
        ServiceLine.stub(:new).and_return(mock_service_line(:organizational_services => mock_model(Array, :build => [])))
        get :new
        assigns[:service_line].should equal(mock_service_line)
      end
    end

    describe "GET edit" do
      it "assigns the requested service_line as @service_line" do
        ServiceLine.stub(:find).with("37").and_return(mock_service_line)
        get :edit, :id => "37"
        assigns[:service_line].should equal(mock_service_line)
      end
    end

    describe "POST create" do

      describe "with valid params" do
        it "assigns a newly created service_line as @service_line" do
          ServiceLine.stub(:new).with({'these' => 'params'}).and_return(mock_service_line(:save => true))
          post :create, :service_line => {:these => 'params'}
          assigns[:service_line].should equal(mock_service_line)
        end

        it "redirects to the created service_line" do
          ServiceLine.stub(:new).and_return(mock_service_line(:save => true))
          post :create, :service_line => {}
          response.should redirect_to(service_line_url(mock_service_line))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved service_line as @service_line" do
          ServiceLine.stub(:new).with({'these' => 'params'}).and_return(mock_service_line(:save => false))
          post :create, :service_line => {:these => 'params'}
          assigns[:service_line].should equal(mock_service_line)
        end

        it "re-renders the 'new' template" do
          ServiceLine.stub(:new).and_return(mock_service_line(:save => false))
          post :create, :service_line => {}
          response.should render_template('new')
        end
      end

    end

    describe "PUT update" do

      describe "with valid params" do
        it "updates the requested service_line" do
          ServiceLine.should_receive(:find).with("37").and_return(mock_service_line)
          mock_service_line.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :service_line => {:these => 'params'}
        end

        it "assigns the requested service_line as @service_line" do
          ServiceLine.stub(:find).and_return(mock_service_line(:update_attributes => true))
          put :update, :id => "1"
          assigns[:service_line].should equal(mock_service_line)
        end

        it "redirects to the service_line" do
          ServiceLine.stub(:find).and_return(mock_service_line(:update_attributes => true))
          put :update, :id => "1"
          response.should redirect_to(service_line_url(mock_service_line))
        end
      end

      describe "with invalid params" do
        it "updates the requested service_line" do
          ServiceLine.should_receive(:find).with("37").and_return(mock_service_line)
          mock_service_line.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :service_line => {:these => 'params'}
        end

        it "assigns the service_line as @service_line" do
          ServiceLine.stub(:find).and_return(mock_service_line(:update_attributes => false))
          put :update, :id => "1"
          assigns[:service_line].should equal(mock_service_line)
        end

        it "re-renders the 'edit' template" do
          ServiceLine.stub(:find).and_return(mock_service_line(:update_attributes => false))
          put :update, :id => "1"
          response.should render_template('edit')
        end
      end

    end

    describe "DELETE destroy" do
      it "destroys the requested service_line" do
        ServiceLine.should_receive(:find).with("37").and_return(mock_service_line)
        mock_service_line.should_receive(:destroy)
        delete :destroy, :id => "37"
      end

      it "redirects to the service_lines list" do
        ServiceLine.stub(:find).and_return(mock_service_line(:destroy => true))
        delete :destroy, :id => "1"
        response.should redirect_to(service_lines_url)
      end
    end
  end
end
