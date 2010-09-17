class PeopleController < ApplicationController
  before_filter :permit_user,  :only => [:index, :directory, :search, :search_results, :versions, :new, :create, :update_ctsa_reporting_year]
  before_filter :permit_admin, :only => [:upload, :revert]

  def index
    params[:search] ||= {}
    @search = Client.search(params[:search])
    @people = @search.paginate(:page => params[:page], :per_page => 20)
    respond_to do |format|
      format.html # index.html.erb
      format.csv { render :csv => @search.all }
    end
  end
  
  def incomplete
    params[:search] ||= {}
    case params[:criteria]
    when "netid"
      params[:search][:netid_equals] = nil
    when "employeeid"
      params[:search][:employeeid_equals] = nil
    when "ctsa"
      params[:search][:specialty_id_equals] = nil
      params[:search][:era_commons_username_equals] = nil
    end
    @search = Client.search(params[:search])
    @people = @search.paginate(:page => params[:page], :per_page => 20)
  end
  
  # GET /people/1/edit
  def edit
    determine_person
    @person.imported = false
  end
  
  # PUT /people/1
  # PUT /people/1.xml
  def update
    determine_person

    respond_to do |format|
      if @person.update_attributes(params[@person.class.to_s.downcase.to_sym])
        redirect_path = (@person.netid == current_user.username) ? edit_person_path(@person) : people_path
        flash[:notice] = 'Person was successfully updated.'
        format.html { redirect_to(redirect_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # POST /update_ctsa_reporting_year
  def update_ctsa_reporting_year
    current_year = Time.now.year
    
    @search = Client.search(params[:search])
    @people = @search.paginate(:page => params[:page], :per_page => 20)
    
    @people.each do |person|
      reporting_years = person.ctsa_reporting_years
      if params["people_ids"].include?(person.id.to_s)
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
    @person = Person.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # POST /people
  # POST /people.xml
  def create
    @person = Person.new(params[:person])

    respond_to do |format|
      if @person.save
        flash[:notice] = 'Person was successfully created.'
        format.html { redirect_to(people_path) }
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
      Person.import_data(params[:file].open, find_or_create_user)
      redirect_to people_path
    end
  end

  # GET /people/search
  def search
    @organizational_unit_id = params[:organizational_unit_id]
  end
  
  # POST /people/search_results
  def search_results
    @organizational_unit_id = params[:organizational_unit_id]
    @redirect_action = params[:redirect_action]
    @people = FacultyWebService.locate(params)
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
  
end