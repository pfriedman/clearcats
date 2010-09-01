class PeopleController < ApplicationController
  before_filter :permit_user,  :only => [:index, :directory, :search, :search_results, :versions, :new, :create]
  before_filter :permit_admin, :only => [:upload, :revert]

  def index
    params[:search] ||= {}
    @search = Person.search(params[:search])
    @people = @search.paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html # index.html.erb
      format.csv { render :csv => @search.all }
    end
  end
  
  # GET /people/1/edit
  def edit
    determine_person
  end
  
  # PUT /people/1
  # PUT /people/1.xml
  def update
    determine_person

    respond_to do |format|
      if @person.update_attributes(params[:person])
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
    Person.import_data(params[:file].open, find_or_create_user)
    redirect_to people_path
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