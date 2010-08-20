require 'spec_helper'

describe CtsaReportsController do

  def mock_ctsa_report(stubs={})
    @mock_ctsa_report ||= mock_model(CtsaReport, stubs)
  end

  context "with an authenticated user" do
    before(:each) do
      login(user_login)
    end

    describe "GET index" do
      it "assigns all ctsa_reports as @ctsa_reports" do
        CtsaReport.stub(:search).and_return([mock_ctsa_report])
        get :index
        assigns[:ctsa_reports].should == [mock_ctsa_report]
      end
    end

    describe "GET new" do
      it "assigns a new ctsa_report as @ctsa_report" do
        CtsaReport.stub(:new).and_return(mock_ctsa_report)
        get :new
        assigns[:ctsa_report].should equal(mock_ctsa_report)
      end
    end

    describe "GET edit" do
      it "assigns the requested ctsa_report as @ctsa_report" do
        CtsaReport.stub(:find).with("37").and_return(mock_ctsa_report)
        get :edit, :id => "37"
        assigns[:ctsa_report].should equal(mock_ctsa_report)
      end
    end

    describe "POST create" do

      describe "with valid params" do
        it "assigns a newly created ctsa_report as @ctsa_report" do
          CtsaReport.stub(:new).with({'these' => 'params'}).and_return(mock_ctsa_report(:save => true))
          post :create, :ctsa_report => {:these => 'params'}
          assigns[:ctsa_report].should equal(mock_ctsa_report)
        end

        it "redirects to the created ctsa_report" do
          CtsaReport.stub(:new).and_return(mock_ctsa_report(:save => true))
          post :create, :ctsa_report => {}
          response.should redirect_to(ctsa_reports_url)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved ctsa_report as @ctsa_report" do
          CtsaReport.stub(:new).with({'these' => 'params'}).and_return(mock_ctsa_report(:save => false))
          post :create, :ctsa_report => {:these => 'params'}
          assigns[:ctsa_report].should equal(mock_ctsa_report)
        end

        it "re-renders the 'new' template" do
          CtsaReport.stub(:new).and_return(mock_ctsa_report(:save => false))
          post :create, :ctsa_report => {}
          response.should render_template('new')
        end
      end

    end

    describe "PUT update" do

      describe "with valid params" do
        it "updates the requested ctsa_report" do
          CtsaReport.should_receive(:find).with("37").and_return(mock_ctsa_report)
          mock_ctsa_report.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :ctsa_report => {:these => 'params'}
        end

        it "assigns the requested ctsa_report as @ctsa_report" do
          CtsaReport.stub(:find).and_return(mock_ctsa_report(:update_attributes => true))
          put :update, :id => "1"
          assigns[:ctsa_report].should equal(mock_ctsa_report)
        end

        it "redirects to the ctsa_report" do
          CtsaReport.stub(:find).and_return(mock_ctsa_report(:update_attributes => true))
          put :update, :id => "1"
          response.should redirect_to(ctsa_reports_url)
        end
      end

      describe "with invalid params" do
        it "updates the requested ctsa_report" do
          CtsaReport.should_receive(:find).with("37").and_return(mock_ctsa_report)
          mock_ctsa_report.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :ctsa_report => {:these => 'params'}
        end

        it "assigns the ctsa_report as @ctsa_report" do
          CtsaReport.stub(:find).and_return(mock_ctsa_report(:update_attributes => false))
          put :update, :id => "1"
          assigns[:ctsa_report].should equal(mock_ctsa_report)
        end

        it "re-renders the 'edit' template" do
          CtsaReport.stub(:find).and_return(mock_ctsa_report(:update_attributes => false))
          put :update, :id => "1"
          response.should render_template('edit')
        end
      end

    end

    describe "DELETE destroy" do
      it "destroys the requested ctsa_report" do
        CtsaReport.should_receive(:find).with("37").and_return(mock_ctsa_report)
        mock_ctsa_report.should_receive(:destroy)
        delete :destroy, :id => "37"
      end

      it "redirects to the ctsa_reports list" do
        CtsaReport.stub(:find).and_return(mock_ctsa_report(:destroy => true))
        delete :destroy, :id => "1"
        response.should redirect_to(ctsa_reports_url)
      end
    end
  end
end
