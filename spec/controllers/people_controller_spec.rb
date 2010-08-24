require 'spec_helper'

describe PeopleController do
  def mock_person(stubs={})
    @mock_person ||= mock_model(Person, stubs)
  end

  before(:each) do
    login(user_login)
  end

  describe "GET index" do
    it "should render the index page" do
      get :index
      response.should be_success
    end
  end
  
  describe "GET edit" do
    it "assigns the requested person as @person" do
      Person.stub(:find).with("37").and_return(mock_person)
      get :edit, :id => "37"
      assigns[:person].should equal(mock_person)
    end
  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested person" do
        Person.should_receive(:find).with("37").and_return(mock_person)
        mock_person.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :person => {:these => 'params'}
      end

      it "assigns the requested person as @person" do
        Person.stub(:find).and_return(mock_person(:update_attributes => true))
        put :update, :id => "1"
        assigns[:person].should equal(mock_person)
      end

      it "redirects to the person" do
        Person.stub(:find).and_return(mock_person(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(people_url)
      end
    end

    describe "with invalid params" do
      it "updates the requested person" do
        Person.should_receive(:find).with("37").and_return(mock_person)
        mock_person.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :person => {:these => 'params'}
      end

      it "assigns the person as @person" do
        Person.stub(:find).and_return(mock_person(:update_attributes => false))
        put :update, :id => "1"
        assigns[:person].should equal(mock_person)
      end

      it "re-renders the 'edit' template" do
        Person.stub(:find).and_return(mock_person(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end
  
  describe "GET upload" do
    it "should process the upload file and redirect the user to the people index page" do
      tmp = Tempfile.new("test")
      Person.stub(:import_data).with(tmp).and_return(true)
      get :upload, :file => tmp
      response.should redirect_to people_path
    end
  end

  describe "GET search" do
    it "should render the search form" do
      get :search
      response.should be_success
    end
  end

  describe "POST search" do
    describe "with valid netid" do
      it "assigns @people with the search results" do
        FacultyWebService.stub!(:locate).and_return([mock_person(:save => true)])
        post :search_results, {:these => 'params'}
        assigns[:people].should == [mock_person]
      end
    end
  end

end
