class PublicationsController < ApplicationController
  before_filter :permit_user,  :only => [:versions]
  before_filter :permit_admin, :only => [:revert]
  layout proc { |controller| controller.request.xhr? ? nil : 'application'  } 

  def index
    if params[:person_id]
      params[:search]           ||= Hash.new
      params[:search][:person_id] = params[:person_id]
      params[:search][:order]   ||= "descend_by_publication_date"
      year = params[:view_all].blank? ? SYSTEM_CONFIG["ctsa_base_line_year"].to_i : 1900
      params[:search][:publication_date_after] = Date.new(year,1,1)
      
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
      format.html do
        render 'new'
      end
      format.js do
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
        format.html do 
          flash[:notice] = "Publication was successfully created."
          redirect_to edit_publication_url(@publication)
          return
        end
        format.js do
          @search = Publication.search(params[:search])
          @publications = @search.all
          render :update do |page|
            page.replace "publications", :partial => "/publications/list", :locals => { :search => params[:search], :service => @service, :person => @person, :publications => @publications }
          end
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
      format.html do
        @show_close_button = false
        render 'edit' 
      end
      format.js do
        @show_close_button = true
        render 'edit'
      end
    end
  end
  
  # POST /publications
  def update
    params[:search]    ||= Hash.new
    params[:person_id] ||= params[:publication][:person_id] if params[:publication]
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
            page.replace "publications", :partial => "/publications/list", :locals => { :search => params[:search], :service => @service, :person => @person, :publications => @publications }
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
    @person.publications.each do |pub|
      reporting_years = pub.ctsa_reporting_years
      if !params["publication_ids"].blank? and params["publication_ids"].include?(pub.id.to_s)
        # Publications are unique and can only have one reporting year unlike awards and people
        if reporting_years.blank?
          pub.ctsa_reporting_years = [current_year]
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
  
  def incomplete
    params[:search] ||= {}
    params[:search][:invalid_for_ctsa] = true
    @search = Publication.search(params[:search])
    @publications = @search.paginate(:page => params[:page], :per_page => 20)
  end
  
  private
  
    def populate_service_and_person
      @show_header    = request.xhr?
      @search_params  = params[:search]
      if params[:service_id]
        @service = Service.find(params[:service_id])
        @person  = @service.person
      elsif params[:person_id]
        determine_person(:person_id)
      end
    end
  
end