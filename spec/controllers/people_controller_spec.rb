require 'spec_helper'

describe PeopleController do
  def mock_person(stubs={})
    @mock_person ||= mock_model(Person, stubs)
  end

  before(:each) do
    login(user_login)
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
