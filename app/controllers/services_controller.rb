class ServicesController < ApplicationController
  permit :Admin, :User

  def index
    @user_organizational_units = determine_org_units_for_user
    params[:search] ||= Hash.new
    params[:search][:service_line_organizational_unit_id_eq_any] = @user_organizational_units.collect(&:id) unless @user_organizational_units.blank?
    params[:search][:person_id] = params[:person_id] if params[:person_id]
    
    @search = Service.search(params[:search])
    @services = @search.paginate(:page => params[:page], :per_page => 20)
  end
  
  def my_services
    params[:search] ||= Hash.new
    params[:search][:created_by_equals] ||= current_user.username
    params[:search][:order] ||= "descend_by_updated_at"

    if params[:completed]
      params[:search][:state_equals] ||= "completed"
    else
      params[:search][:state_does_not_equal] ||= "completed"
    end
    
    @search = Service.search(params[:search])
    @services = @search.paginate(:page => params[:page], :per_page => 20)
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @service }
    end
  end

  def new
    @service = Service.new
    @search  = Service.search(:created_by_equals => current_user.username, :state_does_not_equal => "completed")
    @pending_services = @search.paginate(:page => params[:page], :per_page => 20)
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @service }
    end
  end
  
  def choose_person
    if !params[:search].blank?
      people  = Person.search(params[:search]).all
      faculty = FacultyWebService.locate(params[:search])
      @people = (faculty + people).uniq
    end
    get_service
  end
  
  def choose_service_line
    get_service
    ids = current_user.group_memberships.collect(&:affiliate_ids).flatten.map(&:to_i)
    if ids.blank?
      @organizational_units = OrganizationalUnit.all(:order => :name)
    else
      @organizational_units = OrganizationalUnit.find_by_cc_pers_affiliate_ids(ids).sort_by { |ou| ou.name }
    end
  end
  
  # A service will be created after the user selects either the client or the service line
  # The redirect will be determined by the service
  def create
    
    if params[:service].blank? or (params[:service][:service_line_id].blank? and params[:service][:person_id].blank?)
      if request.referrer.include?("choose_person")
        flash[:notice] = "You must take some action. Please select a person."
      else
        flash[:notice] = "You must take some action. Please select a service line."
      end
      redirect_to :back
    else
      @service = Service.new(params[:service])

      if @service.save!
        flash[:notice] = 'Service was successfully created.'
        determine_redirect
      else
        render :action => "new"
      end
    end
  end
  
  def create_service_for_person
    person   = Person.find(params[:person_id])
    @service = Service.new(:person => person)

    if @service.save!
      flash[:notice] = 'Service was successfully created.'
      determine_redirect
    else
      flash[:warning] = "Could not create service for #{person}"
      redirect_to :back
    end
  end
  
  def edit
    get_service
    @person = @person.amplify! if @person
    # 
    # if ["staging", "production"].include?(Rails.env)
    #   if @person and @person.netid
    #     usr = Bcsec.authority.find_user(@person.netid) 
    #     if usr
    #       Bcsec::User::ATTRIBUTES.each do |a|
    #         next if a.to_s.downcase == "country"
    #         @person.send("#{a}=", usr.send("#{a}").to_s) if @person.respond_to?("#{a}=") and @person.send("#{a}").blank?
    #       end
    #     end
    #   end
    # end
  end
  
  def update_person
    process_update_request
  end

  def continue
    process_update_request
  end
  
  def update
    process_update_request
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
    @search = Publication.search(@search_params)
    @publications = @search.all
  end
  
  def choose_awards
    get_service
    FacultyWebService.awards_for_employee({:employeeid => @service.person.employeeid})
    params[:search] ||= Hash.new
    params[:search][:person_id] = @service.person.id
    params[:search][:order] ||= "ascend_by_project_period_start_date"
    @search_params = params[:search]
    @search = Award.search(@search_params)
    @awards = @search.all
  end
  
  def choose_approvals
    get_service
  end
  
  def update_approvals
    process_update_request
  end
  
  def surveyable
    get_service
    @survey = Survey.first(:conditions => { :common_namespace => "clearcats", :common_identifier => "satisfaction_survey" } )
  end
  
  def survey
    get_service
    @survey = Survey.find_by_access_code(params[:survey_code])
    @response_set = ResponseSet.create(:survey => @survey, :user_id => (@current_user.nil? ? @current_user : @current_user.id), :service => @service)
    if (@survey && @response_set)
      flash[:notice] = t('surveyor.survey_started_success')
      redirect_to(edit_my_survey_path(:survey_code => @survey.access_code, :response_set_code  => @response_set.access_code))
    else
      flash[:notice] = t('surveyor.Unable_to_find_that_survey')
      redirect_to :controller => :services, :action => :surveyable, :id => @service
    end
  end
  
  def completed
    redirect_to :controller => "services", :action => "my_services"
  end
  
  # DELETE /services/1
  # DELETE /services/1.xml
  def destroy
    @service = Service.find(params.delete(:id))
    person = @service.person
    @service.destroy

    respond_to do |format|
      params.delete(:action)
      flash[:link_notice] = "Service has been deleted. <br />Go to the <a href=#{people_path}>Client List</a> to remove the ctsa reportable field for #{person} if desired."
      format.html { redirect_to(services_url(params)) }
      format.xml  { head :ok }
    end
  end
  
  
  private 
  
    def process_update_request
      get_service
      update_service
      update_client
      determine_redirect
    end
  
    def get_service
      if params[:id]
        @service = Service.find(params[:id])
      else
        @service = Service.new
      end
      @person = @service.person
    end
    
    def update_service
      @service.update_attributes(params[:service]) if params[:service]
    end
    
    def update_client
      attr_params = {}
      # Handle polymorphic person - params key dependent on person class
      [:person, :client, :user].each { |e| attr_params = attr_params.merge(params[e]) unless params[e].blank? }
      if @service.person.nil?
        @service.person = Client.new(attr_params)
      else
        @service.person.update_attributes(attr_params)
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
        flash[:notice] = "#{@service.service_line} for #{@service.person} is complete" if @service.state == "completed"
        redirect_to :controller => "services", :action => @service.state, :id => @service
      end
    end
  
end