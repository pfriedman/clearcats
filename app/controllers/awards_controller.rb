class AwardsController < ApplicationController
  before_filter :permit_user,  :only => [:new, :create, :versions, :update_ctsa_reporting_year]
  before_filter :permit_admin, :only => [:revert]
  layout proc { |controller| controller.request.xhr? ? nil : 'application'  } 

  def index
    if params[:person_id]
      @show_header = true
      params[:search]           ||= Hash.new
      params[:search][:person_id] = params[:person_id]
      params[:search][:order]   ||= "ascend_by_project_period_start_date"
      params[:search][:project_period_end_date_after] = Date.new(CTSA_BASE_LINE_YEAR,1,1) if params[:view_all].blank?
      
      populate_service_and_person
      FacultyWebService.awards_for_employee({:employeeid => @person.employeeid}) unless @person.employeeid.blank?
      @search = Award.search(@search_params)
      @awards = @search.all
    else
      flash[:notice] = "Awards can be viewed only in the context of a person."
      redirect_to people_path
    end
  end

  def details
    @award = Award.find(params[:id])
  end

  def new
    populate_common
    @award = Award.new(:person_id => @person.id)
  end

  # GET /awards/edit
  def edit
    populate_common
    @award = Award.find(params[:id])
  end
  
  def create
    @search_params  = params[:search_params]
    @award          = Award.new(params[:award])
    populate_service_and_person

    respond_to do |format|
      if @award.save
        format.js do
          @search = Award.search(params[:search])
          @awards = @search.all
          render :update do |page|
            page.replace "awards", :partial => "/awards/list", :locals => { :search => params[:search] }
          end
        end
        format.html do 
          flash[:notice] = "Award was successfully created."
          redirect_to edit_award_url(@award)
          return
        end
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  # POST /awards
  def update
    populate_service_and_person
    @award = Award.find(params[:id])
    respond_to do |format|
      if @award.update_attributes(params[:award])
        format.html do 
          flash[:notice] = "Award was successfully updated."
          redirect_to edit_award_url(@award)
          return
        end
        format.js do
          @search = Award.search(params[:search])
          @awards = @search.all
          render :update do |page|
            page.replace "awards", :partial => "/awards/list", :locals => { :search => params[:search] }
          end
        end        
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  # POST /update_ctsa_reporting_year
  def update_ctsa_reporting_year
    populate_service_and_person
    current_year = current_ctsa_reporting_year
    @person.awards.each do |award|
      reporting_years = award.ctsa_reporting_years
      if params["award_ids"].include?(award.id.to_s)
        if !reporting_years.include?(current_year)
          award.ctsa_reporting_years = (reporting_years << current_year) 
          award.save
        end
      elsif reporting_years.include?(current_year)
        reporting_years.delete(current_year)
        award.ctsa_reporting_years = reporting_years
        award.save
      end
    end
    flash[:notice] = "Awards were updated successfully"
    redirect_to person_awards_path(@person) # TODO: determine if there was a service and redirect appropriately
  end
  
  def versions
    @award = Award.find(params[:id])
    send_data(@award.export_versions, :filename => "award_#{@award.id}_versions.csv") if params[:export]
  end
  
  def revert
    revertit(Award)
  end
  
  def incomplete
    params[:search] ||= {}
    params[:search][:organization_id_equals] = nil
    params[:search][:activity_code_id_equals] = nil
    params[:search][:grant_number_equals] = nil
    @search = Award.search(params[:search])
    @awards = @search.paginate(:page => params[:page], :per_page => 20)
  end
  
  private
  
    def populate_common
      populate_service_and_person
      @show_header    = request.xhr?
      @non_phs_orgs   = NonPhsOrganization.all(:order => :code)
      @phs_orgs       = PhsOrganization.all(:order => :code)
      @activity_codes = ActivityCode.all(:order => :code)
    end
    
    def populate_service_and_person
      @search_params  = params[:search]
      if params[:service_id]
        @service = Service.find(params[:service_id])
        @person  = @service.person
      elsif params[:person_id]
        determine_person(:person_id)
      end
    end
  
end