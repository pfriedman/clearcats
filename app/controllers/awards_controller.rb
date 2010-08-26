class AwardsController < ApplicationController
  permit :Admin, :User
  layout proc { |controller| controller.request.xhr? ? nil : 'application'  } 

  def index
    if params[:person_id]
      
      params[:search]           ||= Hash.new
      params[:search][:person_id] = params[:person_id]
      params[:search][:order]   ||= "ascend_by_project_period_start_date"
      
      populate_service_and_person
      FacultyWebService.awards_for_employee({:employeeid => @person.employeeid})
      @awards = Award.search(@search_params)
    else
      flash[:notice] = "Awards can be viewed only in the context of a person."
      redirect_to people_path
    end
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
    @service        = Service.find(params[:service_id])

    respond_to do |format|
      if @award.save
        format.js do
          @awards = Award.search(params[:search])
          render :update do |page|
            page.replace "awards", :partial => "/awards/list", :locals => { :search => params[:search] }
          end
        end
        format.html { redirect_to edit_award_url(@award) }
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
        format.html { redirect_to edit_award_url(@award) }
        format.js do
          @awards = Award.search(params[:search])
          render :update do |page|
            page.replace "awards", :partial => "/awards/list", :locals => { :search => params[:search] }
          end
        end
        
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def versions
    @award = Award.find(params[:id])
    send_data(@award.export_versions, :filename => "award_#{@award.id}_versions.csv") if params[:export]
  end
  
  def revert
    revertit(Award)
  end
  
  private
  
    def populate_common
      populate_service_and_person

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
        @person  = Person.find(params[:person_id])
      end
    end
  
end