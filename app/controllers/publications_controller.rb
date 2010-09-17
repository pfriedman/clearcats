class PublicationsController < ApplicationController
  before_filter :permit_user,  :only => [:versions]
  before_filter :permit_admin, :only => [:revert]
  layout proc { |controller| controller.request.xhr? ? nil : 'application'  } 

  def index
    if params[:person_id]
      params[:search]           ||= Hash.new
      params[:search][:person_id] = params[:person_id]
      params[:search][:order]   ||= "ascend_by_publication_date"
      
      populate_service_and_person  
      LatticeGridWebService.investigator_publications_search(@person.netid) unless @person.netid.blank?

      @search = Publication.search(@search_params)
      @publications = @search.all
    else
      flash[:notice] = "Publications can be viewed only in the context of a person."
      redirect_to people_path
    end
  end
  
  def new
    params[:search] ||= Hash.new
    populate_service_and_person
    @publication = Publication.new(:person_id => @person.id)
    respond_to do |format|
      format.js do
        @show_close_button = true
        render 'new'
      end
      format.html do
        @show_close_button = false
        render 'new' 
      end
    end
  end
  
  def create
    @search_params  = params[:search_params]
    @publication    = Publication.new(params[:publication])
    populate_service_and_person

    respond_to do |format|
      if @publication.save
        format.js do
          @search = Publication.search(params[:search])
          @publications = @search.all
          render :update do |page|
            page.replace "publications", :partial => "/publications/list", :locals => { :search => params[:search] }
          end
        end
        format.html do 
          flash[:notice] = "Publication was successfully created."
          redirect_to edit_publication_url(@publication)
          return
        end
      else
        format.html { render :action => "new" }
      end
    end
  end

  # GET /publications/edit
  def edit
    params[:search] ||= Hash.new
    populate_service_and_person
    @publication = Publication.find(params[:id])
    respond_to do |format|
      format.js do
        @show_close_button = true
        render 'edit'
      end
      format.html do
        @show_close_button = false
        render 'edit' 
      end
    end
  end
  
  # POST /publications
  def update
    params[:search] ||= Hash.new
    populate_service_and_person
    @publication = Publication.find(params[:id])
    respond_to do |format|
      if @publication.update_attributes(params[:publication])
        format.html do
          flash[:notice] = "Publication was successfully updated"
          redirect_to edit_publication_path(@publication)
        end
        format.js do
          @search = Publication.search(params[:search])
          @publications = @search.all
          render :update do |page|
            page.replace "publications", :partial => "/publications/list", :locals => { :search => params[:search] }
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
    current_year = Time.now.year
    @person.publications.each do |pub|
      reporting_years = pub.ctsa_reporting_years
      if params["publication_ids"].include?(pub.id.to_s)
        if !reporting_years.include?(current_year)
          pub.ctsa_reporting_years = (reporting_years << current_year) 
          pub.save
        end
      elsif reporting_years.include?(current_year)
        reporting_years.delete(current_year)
        pub.ctsa_reporting_years = reporting_years
        pub.save
      end
    end
    flash[:notice] = "Publications were updated successfully"
    redirect_to person_publications_path(@person) # TODO: determine if there was a service and redirect appropriately
  end
  
  def versions
    @publication = Publication.find(params[:id])
    if params[:export]
      send_data(@publication.export_versions, :filename => "publication_#{@publication.id}_versions.csv")
    end
  end
  
  def revert
    revertit(Publication)
  end
  
  private
  
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