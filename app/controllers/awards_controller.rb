class AwardsController < ApplicationController
  layout nil

  def new
    populate_common
    @award = Award.new(:person_id => @service.person.id)
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
        @awards = Award.search(params[:search])
        format.js do
          render :update do |page|
            page.replace "awards",
              :partial => "/awards/list", :locals => { :service => @service, :awards => @awards, :person => @service.person, :search => params[:search] }
          end
        end
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  # POST /awards
  def update
    @search_params  = params[:search_params]
    @award          = Award.find(params[:id])
    @service        = Service.find(params[:service_id])
    respond_to do |format|
      if @award.update_attributes(params[:award])
        @awards = Award.search(params[:search])
        format.js do
          render :update do |page|
            page.replace "awards",
              :partial => "/awards/list", :locals => { :service => @service, :awards => @awards, :person => @service.person, :search => params[:search] }
          end
        end
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  private
  
    def populate_common
      @search_params  = params[:search_params]
      @service        = Service.find(params[:service_id])

      @non_phs_orgs   = NonPhsOrganization.all(:order => :code)
      @phs_orgs       = PhsOrganization.all(:order => :code)
      @activity_codes = ActivityCode.all(:order => :code)
    end
  
end