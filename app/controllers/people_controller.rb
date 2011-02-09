class PeopleController < ApplicationController
  before_filter :permit_user,  :only => [:index, :directory, :search, :search_results, :versions, :new, :create, :update_ctsa_reporting_year]
  before_filter :permit_admin, :only => [:upload, :revert, :merge]

  def index
    params[:search]         ||= Hash.new
    params[:search][:order] ||= "ascend_by_last_name"
    purge_search_params

    @search = Client.search(params[:search])
    @people = @search.paginate(:select => "distinct people.*", :page => params[:page], :per_page => 20)
    respond_to do |format|
      format.html # index.html.erb
      format.csv { render :csv => @search.all }
    end
  end
  
  def incomplete
    params[:search] ||= Hash.new
    case params[:criteria]
    when "netid"
      params[:search][:netid_equals] = nil
    when "employeeid"
      params[:search][:employeeid_equals] = nil
    when "era_commons_username"
      params[:search][:era_commons_username_equals] = nil
    when "specialty"
      params[:search][:specialty_id_equals] = nil
    else
      params[:search][:invalid_for_ctsa_reporting] = true
    end
    @search = Client.search(params[:search])
    @people = @search.paginate(:page => params[:page], :per_page => 20)
  end
  
  # GET /people/1/edit
  def edit
    determine_person
    @person = @person.amplify
    @person.imported = false
  end
  
  # PUT /people/1
  # PUT /people/1.xml
  def update
    determine_person

    respond_to do |format|
      if @person.update_attributes(params[@person.class.to_s.downcase.to_sym])
        redirect_path = (@person.netid == current_user.username) ? edit_person_path(@person) : people_path
        format.html do 
          if faculty_member?
            flash[:notice] = 'Person was successfully updated.'
            redirect_to person_awards_path(@person)
          else
            flash[:notice] = 'Person was successfully updated. Please select action below to continue working with this record.'
            redirect_to edit_person_path(@person)
          end
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # POST /update_ctsa_reporting_year
  def update_ctsa_reporting_year
    current_year = current_ctsa_reporting_year
    
    @search = Client.search(params[:search])
    @people = @search.paginate(:page => params[:page], :per_page => 20, :readonly => false)
    
    @people.each do |person|
      reporting_years = person.ctsa_reporting_years
      if !params["people_ids"].nil? and params["people_ids"].include?(person.id.to_s)
        if !reporting_years.include?(current_year)
          person.ctsa_reporting_years = (reporting_years << current_year) 
          person.save
        end
      elsif reporting_years.include?(current_year)
        reporting_years.delete(current_year)
        person.ctsa_reporting_years = reporting_years
        person.save
      end
    end
    flash[:notice] = "People were updated successfully"
    redirect_to people_path(:page => params[:page], :search => params[:search])
  end


  # GET /people/new
  # GET /people/new.xml
  def new
    @person = Client.new(params[:person])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # POST /people
  # POST /people.xml
  def create
    @person = Client.new(params[:client])

    respond_to do |format|
      if @person.save
        flash[:notice] = 'Person was successfully created. Please select action below to continue working with this record.'
        format.html { redirect_to(edit_person_path(@person)) }
        format.xml  { render :xml => @person, :status => :created, :location => @person }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  
  def directory
    @people = FacultyWebService.locate(params[:search]) unless params[:search].blank?
  end
  
  def upload
    if request.post? 
      if params[:file].blank?
        flash.now[:warning] = "You must select a file to upload."
        render :action => "upload"
      else
        Person.import_data(params[:file].open, find_or_create_user)
        flash[:notice] = "Data was successfully uploaded."
        redirect_to :controller => "services", :action => "my_services"
      end
    end
  end
  
  def sample_upload_file
    send_file("#{Rails.root}/lib/data/sample_clearcats_investigator_upload_file.csv", :file_name => "sample_clearcats_investigator_upload_file.csv", :type => "text/csv")
  end

  # GET /people/search
  def search
    @organizational_unit_id = params[:organizational_unit_id]
  end
  
  # POST /people/search_results
  def search_results
    if params[:netid].blank? and params[:last_name].blank?
      flash[:warning] = "Please enter search criteria"
      redirect_to :back
    else
      @organizational_unit_id = params[:organizational_unit_id]
      search  = {:netid_like => params[:netid], :last_name_like => params[:last_name]}
      people  = Person.search(search).all
      faculty = FacultyWebService.locate(params)
      
      @people = (faculty + people).uniq
    end
  end

  def versions
    @person = Person.find(params[:id])
    if params[:export]
      send_data(@person.export_versions, :filename => "#{@person.to_s.downcase.gsub(' ', '_')}_versions.csv")
    end
  end
  
  def revert
    revertit(Person)
  end
  
  def version
    @version = Person.find(params[:id]).versions.find(params[:version_id])
    @person  = @version.reify
  end
  
  def merge
    if request.post?
      
      if !params[:netid].blank? and !params[:era_commons_username].blank?
        ClientMerger.merge(params[:era_commons_username], params[:netid])
        flash[:notice] = 'Records were successfully merged.'
        redirect_to people_path(:search => { :era_commons_username_like => params[:era_commons_username] })
      else
        render :merge
      end
    end
  end
  
  def era_commons_username_search
    #TODO: eventually use the FSM Faculty Database to look up this data, but until that is available use file
    if request.get?
      @era_commons_usernames = nil
    elsif request.post?
      @era_commons_usernames = []
      map = DataScrubber.get_commons_name_map_from_file
      
      if !params[:netid].blank?
        pers = Person.find_by_netid(params[:netid])
        if pers
          eracn = map["#{pers.full_name}"]
          eracn = pers.era_commons_username if eracn.blank?
          @era_commons_usernames << eracn unless eracn.blank?
        end
      end
      
      eracn = map["#{params[:employeeid]}"]
      @era_commons_usernames << eracn unless eracn.blank?
      
      eracn = map["#{params[:first_name]} #{params[:last_name]}"]
      @era_commons_usernames << eracn unless eracn.blank?
      
      @era_commons_usernames = @era_commons_usernames.uniq
    end
    
  end
  
end