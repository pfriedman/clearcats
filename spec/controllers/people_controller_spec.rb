require 'spec_helper'

describe PeopleController do
  def mock_person(stubs={})
    @mock_person ||= mock_model(Person, stubs)
  end

  context "logged in as administrator" do

    before(:each) do
      login(admin_login)
    end

    describe "GET index" do
      it "should render the index page" do
        get :index
        response.should be_success
      end
    end
  
    describe "GET directory" do
      it "assigns all people as @people" do
        FacultyWebService.stub!(:make_request).and_return(netid_response)
        result = FacultyWebService.locate_one({:netid => "wakibbe"})
        get :directory, :search => { :netid => "wakibbe" }
        assigns[:people].should == [result]
      end
    end
  
    describe "GET edit" do
      it "assigns the requested person as @person" do
        Person.stub(:find).with("37").and_return(mock_person(:imported= => true))
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
          Person.stub(:find).and_return(mock_person(:update_attributes => true, :netid => "asdf"))
          put :update, :id => "1"
          assigns[:person].should equal(mock_person)
        end

        it "redirects to the person" do
          Person.stub(:find).and_return(mock_person(:update_attributes => true, :netid => "asdf"))
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
    
    describe "GET new" do
      it "assigns a new person as @person" do
        Person.stub(:new).and_return(mock_person)
        get :new
        assigns[:person].should equal(mock_person)
      end
    end


    describe "POST create" do

      describe "with valid params" do
        it "assigns a newly created activity_type as @activity_type" do
          Person.stub(:new).with({'these' => 'params'}).and_return(mock_person(:save => true))
          post :create, :person => {:these => 'params'}
          assigns[:person].should equal(mock_person)
        end

        it "redirects to the created activity_type" do
          Person.stub(:new).and_return(mock_person(:save => true))
          post :create, :person => {}
          response.should redirect_to(people_path)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved person as @person" do
          Person.stub(:new).with({'these' => 'params'}).and_return(mock_person(:save => false))
          post :create, :person => {:these => 'params'}
          assigns[:person].should equal(mock_person)
        end

        it "re-renders the 'new' template" do
          Person.stub(:new).and_return(mock_person(:save => false))
          post :create, :person => {}
          response.should render_template('new')
        end
      end

    end
  
    describe "GET and POST upload" do
      
      it "should show the user the upload file form" do
        get :upload
        response.should be_success
      end
      
      it "should process the upload file and redirect the user to the people index page" do
        Person.stub(:import_data).and_return(true)
        post :upload, :file => Tempfile.new("test")
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
  
  context "logged in as faculty" do
    before(:each) do
      login(faculty_login)
    end
    
    describe "GET versions" do
      it "should alert the user that the resource is not available" do
        get :versions
        flash[:warning].should == "You do not have access to the resource you requested."
      end
      
      it "should redirect the user to the welcome page" do
        get :versions
        response.should redirect_to :controller => "welcome", :action => "index"
      end 
    end
    
    describe "GET edit" do
      
      it "should allow the user to edit their own profile" do
        faculty = Factory(:person, :netid => "wakibbe") # we know the username of the logged in user
        get :edit, :id => faculty.id + 123              # obviously not the id of the logged in user
        response.should be_success
      end
      
    end
    
  end
  
  context "logged in as user" do
    before(:each) do
      login(user_login)
    end
    
    describe "GET upload" do
      it "should alert the user that the resource is not available" do
        get :upload
        flash[:warning].should == "You do not have access to the resource you requested."
      end
      
      it "should redirect the user to the welcome page" do
        get :upload
        response.should redirect_to :controller => "welcome", :action => "index"
      end 
    end
  end
  
end

def netid_response
  body = '{"interests":["Bioinformatics","Biomedical ontologies","Genomics","Information Systems","Medical Informatics"],"campus":"Chicago","descriptions":["Biomedical Ontologies, Informatics, Bioinformatics, basic and clinical data representation"],"dv_abbr":"NUCATS","basis":"FT","category":"Research","dept_id":"420000","career_track":"Research","degree":"PhD","division":{"picture_dir":null,"dv_abbr":"NUCATS","dept_id":"420000","label_name":"NUCATS","center_flag":1,"dv_room_number":"11th floor","dv_location_id":"0.101E3","appoint_flag":1,"dv_phone":"312-503-1709","dv_url":"http://www.nucats.northwestern.edu/index.html","dv_name":"Northwestern University Clinical and Translational Sciences Institute (NUCATS)","dv_campus_id":"0.1E1","search_name":"NUCATS","division_id":"420010","sau_id":null,"dv_type":"Clinical"},"joint":[],"rank":"Res Assoc Prof","employee_id":"1018461","division_id":"420010","netid":"wakibbe","pmids":[1657962,3100052,11825185,12613351,14681407,14681427,15114363,15306695,15582151,16277761,16299224,16307524,16314072,16381903,16610959,16820428,17090585,17342793,17443163,17452344,17540033,17634620,18178591,18314582,18467348,18974179,19478018,19594883],"last_name":"Kibbe","centers":["Ctr for Genetic Medicine","NUCATS"],"secondary":["Ctr for Genetic Medicine"],"email":"wakibbe@northwestern.edu","middle_name":"A","first_name":"Warren"}'
  resp = mock_model(Net::HTTPOK, :body => body)
  return resp
end
