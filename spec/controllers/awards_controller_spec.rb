require 'spec_helper'

describe AwardsController do

  def mock_award(stubs={})
    @mock_award ||= mock_model(Award, stubs)
  end
  
  context "with an authenticated user" do
    before(:each) do
      login(user_login)
    end

    describe "GET new" do
      it "assigns a new award as @award" do
        Service.should_receive(:find).with("99").and_return(mock_model(Service, :person => mock_model(Person)))
        Award.stub(:new).and_return(mock_award)
        get :new, :service_id => "99"
        assigns[:award].should equal(mock_award)
      end
    end

    describe "GET edit" do
      it "assigns the requested award as @award" do
        Service.should_receive(:find).with("99").and_return(mock_model(Service, :person => mock_model(Person)))
        Award.stub(:find).with("37").and_return(mock_award)
        get :edit, :id => "37", :service_id => "99"
        assigns[:award].should equal(mock_award)
      end
    end

    describe "POST create" do

      describe "with valid params" do
        it "assigns a newly created award as @award" do
          Service.should_receive(:find).with("99").and_return(mock_model(Service, :person => mock_model(Person)))
          Award.stub(:new).with({'these' => 'params'}).and_return(mock_award(:save => true))
          post :create, :award => {:these => 'params'}, :service_id => "99"
          assigns[:award].should equal(mock_award)
        end

        # it "redirects to the created award" do
        #   Service.should_receive(:find).with("99").and_return(mock_model(Service, :person => mock_model(Person)))
        #   Award.stub(:new).and_return(mock_award(:save => true))
        #   post :create, :award => {}, :service_id => "99"
        #   response.should redirect_to(edit_award_url(mock_award))
        # end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved award as @award" do
          Service.should_receive(:find).with("99").and_return(mock_model(Service, :person => mock_model(Person)))
          Award.stub(:new).with({'these' => 'params'}).and_return(mock_award(:save => false))
          post :create, :award => {:these => 'params'}, :service_id => "99"
          assigns[:award].should equal(mock_award)
        end

        it "re-renders the 'new' template" do
          Service.should_receive(:find).with("99").and_return(mock_model(Service, :person => mock_model(Person)))
          Award.stub(:new).and_return(mock_award(:save => false))
          post :create, :award => {}, :service_id => "99"
          response.should render_template('new')
        end
      end

    end

    describe "PUT update" do

      describe "with valid params" do
        it "updates the requested award" do
          Service.should_receive(:find).with("99").and_return(mock_model(Service, :person => mock_model(Person)))
          Award.should_receive(:find).with("37").and_return(mock_award)
          mock_award.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :award => {:these => 'params'}, :service_id => "99"
        end

        # it "assigns the requested award as @award" do
        #   Service.should_receive(:find).with("99").and_return(mock_model(Service, :person => mock_model(Person)))
        #   Award.stub(:find).and_return(mock_award(:update_attributes => true))
        #   put :update, :id => "1", :service_id => "99"
        #   assigns[:award].should equal(mock_award)
        # end

        # it "redirects to the award" do
        #   Service.should_receive(:find).with("99").and_return(mock_model(Service, :person => mock_model(Person)))
        #   Award.stub(:find).and_return(mock_award(:update_attributes => true))
        #   put :update, :id => "1", :service_id => "99"
        #   response.should redirect_to(edit_award_url(mock_award))
        # end
      end

      describe "with invalid params" do
        it "updates the requested award" do
          Service.should_receive(:find).with("99").and_return(mock_model(Service, :person => mock_model(Person)))
          Award.should_receive(:find).with("37").and_return(mock_award)
          mock_award.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :award => {:these => 'params'}, :service_id => "99"
        end

        it "assigns the award as @award" do
          Service.should_receive(:find).with("99").and_return(mock_model(Service, :person => mock_model(Person)))
          Award.stub(:find).and_return(mock_award(:update_attributes => false))
          put :update, :id => "1", :service_id => "99"
          assigns[:award].should equal(mock_award)
        end

        it "re-renders the 'edit' template" do
          Service.should_receive(:find).with("99").and_return(mock_model(Service, :person => mock_model(Person)))
          Award.stub(:find).and_return(mock_award(:update_attributes => false))
          put :update, :id => "1", :service_id => "99"
          response.should render_template('edit')
        end
      end

    end

  end
end
