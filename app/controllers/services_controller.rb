class ServicesController < ApplicationController
  permit :Admin, :User

  def index
    @search = Service.search(params[:search])
    @services = @search.paginate(:page => params[:page], :per_page => 10)
  end

  def new
    @service = Service.new
    @search  = Service.search(:created_by_id_equals => find_or_create_user.id, :state_does_not_equal => "complete")
    @pending_services = @search.paginate(:page => params[:page], :per_page => 10)
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @service }
    end
  end
  
  def choose_person
    if !params[:search].blank?
      @people = FacultyWebService.locate(params[:search])
    end
    get_service
  end
  
  def choose_service_line
    get_service
  end
  
  # A service will be created after the user selects either the client or the service line
  # The redirect will be determined by the service
  def create
    @service = Service.new(params[:service])
    @service.created_by = find_or_create_user

    if @service.save!
      flash[:notice] = 'Service was successfully created.'
      determine_redirect
    else
      render :action => "new"
    end
  end
  
  def edit
    get_service
  end
  
  def update_person
    process_request
  end

  def continue
    process_request
  end
  
  def update
    process_request
  end
  
  def identified
    get_service
    if !request.get?
      update_service
      determine_redirect
    end
  end
  
  def choose_organizational_units
    get_service
  end
  
  def choose_publications
    get_service
    LatticeGridWebService.investigator_publications_search(@service.person.netid)
    
    params[:search] ||= Hash.new
    params[:search][:person_id] = @service.person.id
    params[:search][:order] ||= "ascend_by_publication_date"
    @search_params = params[:search]
    @publications = Publication.search(@search_params)
  end
  
  def choose_awards
    get_service
    FacultyWebService.awards_for_employee({:employeeid => @service.person.employeeid})
    params[:search] ||= Hash.new
    params[:search][:person_id] = @service.person.id
    params[:search][:order] ||= "ascend_by_project_period_start_date"
    @search_params = params[:search]
    @awards = Award.search(@search_params)
  end
  
  def choose_approvals
    get_service
  end
  
  def update_approvals
    process_request
  end
  
  
  private 
  
    def process_request
      get_service
      update_service
      determine_redirect
    end
  
    def get_service
      if params[:id]
        @service = Service.find(params[:id])
      else
        @service = Service.new
      end
    end
    
    def update_service
      @service.person.update_attributes(params[:person]) if params[:person]
      @service.update_attributes(params[:service])       if params[:service]
    end
    
    def determine_redirect
      Rails.logger.info("~~~ Service State [#{@service.id}] = #{@service.state}")

      if @service.initiated?
        redirect_to edit_service_path(@service)
      elsif @service.choose_person?
        redirect_to choose_person_service_path(@service)
      elsif @service.choose_service_line?
        redirect_to choose_service_line_service_path(@service)
      else
        redirect_to :controller => "services", :action => @service.state, :id => @service
      end
    end
  
end