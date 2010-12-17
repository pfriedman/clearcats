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
        mock = mock_person(:imported= => true, :imported => true, :netid => true)
        FacultyWebService.stub(:locate_one).and_return(mock)
        Person.stub(:find).with("37").and_return(mock)
        get :edit, :id => "37"
        assigns[:person].should equal(mock)
      end
    end

    describe "PUT update" do

      describe "with valid params" do
        it "updates the requested person" do
          mock = mock_person(:imported= => true, :imported => true, :netid => true)
          FacultyWebService.stub(:locate_one).and_return(mock)
          Person.should_receive(:find).with("37").and_return(mock)
          mock.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :person => {:these => 'params'}
        end

        it "assigns the requested person as @person" do
          mock = mock_person(:imported= => true, :imported => true, :netid => "asdf")
          FacultyWebService.stub(:locate_one).and_return(mock)
          Person.stub(:find).and_return(mock)
          mock.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "1", :person => {:these => 'params'}
          assigns[:person].should equal(mock)
        end

        it "redirects to the person" do
          
          mock = mock_person(:imported= => true, :imported => true, :netid => "asdf", :update_attributes => true)
          FacultyWebService.stub(:locate_one).and_return(mock)
          Person.stub(:find).and_return(mock)
          mock.should_receive(:update_attributes).with({'these' => 'params'})

          put :update, :id => "1", :person => {:these => 'params'}
          response.should redirect_to(edit_person_url(mock))
        end
      end

      describe "with invalid params" do

        it "assigns the person as @person" do
          mock = mock_person(:imported= => true, :imported => true, :netid => "asdf", :update_attributes => false)
          FacultyWebService.stub(:locate_one).and_return(mock)
          Person.stub(:find).and_return(mock)
          mock.should_receive(:update_attributes).with({'these' => 'params'})

          put :update, :id => "1", :person => {:these => 'params'}
          assigns[:person].should equal(mock_person)
        end

        it "re-renders the 'edit' template" do
          mock = mock_person(:imported= => true, :imported => true, :netid => "asdf", :update_attributes => false)
          FacultyWebService.stub(:locate_one).and_return(mock)
          Person.stub(:find).and_return(mock)
          mock.should_receive(:update_attributes).with({'these' => 'params'})

          put :update, :id => "1", :person => {:these => 'params'}
          response.should render_template('edit')
        end
      end

    end
    
    describe "GET new" do
      it "assigns a new person as @person" do
        Client.stub(:new).and_return(mock_person)
        get :new
        assigns[:person].should equal(mock_person)
      end
    end


    describe "POST create" do

      describe "with valid params" do
        it "assigns a newly created person as @person" do
          Client.stub(:new).with({'these' => 'params'}).and_return(mock_person(:save => true))
          post :create, :client => {:these => 'params'}
          assigns[:person].should equal(mock_person)
        end

        it "redirects to the created person" do
          pers = mock_person(:save => true)
          Client.stub(:new).and_return(pers)
          post :create, :client => {}
          response.should redirect_to(edit_person_path(pers))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved person as @person" do
          Client.stub(:new).with({'these' => 'params'}).and_return(mock_person(:save => false))
          post :create, :client => {:these => 'params'}
          assigns[:person].should equal(mock_person)
        end

        it "re-renders the 'new' template" do
          Client.stub(:new).and_return(mock_person(:save => false))
          post :create, :client => {}
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
        response.should redirect_to :controller => "services", :action => "my_services"
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
          request.env["HTTP_REFERER"] = "/"
          FacultyWebService.stub!(:locate).and_return([mock_person(:save => true)])
          post :search_results, {:netid => 'asdf'}
          assigns[:people].should == [mock_person]
        end
      end
      
      describe "with invalid params" do
        it "redirects people back" do
          request.env["HTTP_REFERER"] = "/"
          FacultyWebService.stub!(:locate).and_return([mock_person(:save => true)])
          post :search_results, {:these => 'params'}
          response.should redirect_to("/")
        end
      end
      
    end
    
    describe "POST update_ctsa_reporting_year" do
      it "updates the reporting year of the person to the current reporting year" do
        client = Factory(:client)
        client.ctsa_reporting_years.should == [2000]
        
        Client.should_receive(:search).and_return([client])
        post :update_ctsa_reporting_year, "people_ids" => [client.id.to_s], :search => {}, :page => 1
        
        person = Client.find(client.id)
        person.ctsa_reporting_years.should == [2000, Time.now.year]
        
        response.should redirect_to(people_path(:page => 1, :search => {}))
      end
      
      it "removes the current reporting year of the person if not sent as a param" do
        client = Factory(:client)
        client.ctsa_reporting_years = (client.ctsa_reporting_years << Time.now.year) 
        client.save!
        
        client.ctsa_reporting_years.should == [2000, Time.now.year]
        
        Client.should_receive(:search).and_return([client])
        post :update_ctsa_reporting_year, "people_ids" => [], :search => {}, :page => 1
        
        person = Client.find(client.id)
        person.ctsa_reporting_years.should == [2000]
      end
    end
    
    describe "GET incomplete" do
      before(:each) do
        @no_netid    = Factory(:client, :netid => nil)
        @no_emplid   = Factory(:client, :employeeid => nil)
        @no_era_name = Factory(:client, :era_commons_username => nil)
        @no_specialty = Factory(:client, :specialty => nil)
        @all = [@no_netid, @no_emplid, @no_era_name, @no_specialty]
      end

      it "should return all people that are incomplete" do
        get :incomplete
        @all.map(&:id).each { |id| assigns[:people].map(&:id).include?(id).should be_true }
      end

      it "should return all people that are incomplete without netids"
      
      # the following throws an error 
      # - private method `binding' called for nil:NilClass
      #
      # it "should return all people that are incomplete without netids" do
      #   get :incomplete, :criteria => "netid"
      #   people_ids = assigns[:people].map(&:id)
      #   people_ids.include?(@no_netid.id).should be_true
      #   people_ids.include?(@no_emplid.id).should_not be_true
      # end

      it "should return all people that are incomplete without employeeids" do
        get :incomplete, :criteria => "employeeid"
        people_ids = assigns[:people].map(&:id)
        people_ids.include?(@no_netid.id).should_not be_true
        people_ids.include?(@no_emplid.id).should be_true
      end

      it "should return all people that are incomplete without era_commons_usernames" do
        get :incomplete, :criteria => "era_commons_username"
        people_ids = assigns[:people].map(&:id)
        people_ids.include?(@no_netid.id).should_not be_true
        people_ids.include?(@no_emplid.id).should_not be_true
        people_ids.include?(@no_era_name.id).should be_true
      end
      
      it "should return all people that are incomplete without a specialty" do
        get :incomplete, :criteria => "specialty"
        people_ids = assigns[:people].map(&:id)
        people_ids.include?(@no_netid.id).should_not be_true
        people_ids.include?(@no_emplid.id).should_not be_true
        people_ids.include?(@no_specialty.id).should be_true
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
        faculty = Factory(:person, :netid => "faculty") # we know the username of the logged in user
        get :edit, :id => faculty.id
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
