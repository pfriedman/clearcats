class ServicesController < ApplicationController

  
  def new
    @service = Service.new
    @pending_services = Service.all(:conditions => ["created_by_id = ? and state <> ?", find_or_create_user.id, "complete"])
    
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

    if @service.save
      @service.update_state
      flash[:notice] = 'Service was successfully created.'
      determine_redirect
    else
      render :action => "new"
    end
  end
  
  def edit
    @service = Service.find(params[:id])
  end
  
  def update_person
    @service = Service.find(params[:id])
    @service.person.update_attributes(params[:person])
    @service.update_state
    determine_redirect
  end

  def continue
    @service = Service.find(params[:id])
    determine_redirect
  end
  
  def update
    @service = Service.find(params[:id])
    @service.update_attributes(params[:service])
    @service.update_state
    determine_redirect
  end
  
  # GET /services/wizard
  # def wizard
  #   @service_line = ServiceLine.find_by_id(params[:service_line_id])
  #   @service = params[:id] ? Service.find(params[:id]) : Service.create!(:service_line => @service_line)
  #   
  #   @service.send "#{params[:aasm_action]}!" if params[:aasm_action]
  #   
  #   render
  # end
  
  private 
  
    def get_service
      if params[:id]
        @service = Service.find(params[:id])
      else
        @service = Service.new
      end
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