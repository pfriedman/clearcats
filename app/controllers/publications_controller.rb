class PublicationsController < ApplicationController
  permit :Admin, :User
  layout proc { |controller| controller.request.xhr? ? nil : 'application'  } 

  def index
    if params[:person_id]
      params[:search]           ||= Hash.new
      params[:search][:person_id] = params[:person_id]
      params[:search][:order]   ||= "ascend_by_publication_date"
      
      populate_service_and_person  
      LatticeGridWebService.investigator_publications_search(@person.netid)

      @publications = Publication.search(@search_params)
    else
      flash[:notice] = "Publications can be viewed only in the context of a person."
      redirect_to people_path
    end
  end

  # GET /publications/edit
  def edit
    params[:search] ||= Hash.new
    populate_service_and_person
    @publication    = Publication.find(params[:id])
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
    @publication    = Publication.find(params[:id])
    respond_to do |format|
      if @publication.update_attributes(params[:publication])
        format.html do
          flash[:notice] = "Publication was successfully updated"
          redirect_to edit_publication_path(@publication)
        end
        format.js do
          @publications = Publication.search(params[:search])
          render :update do |page|
            page.replace "publications", :partial => "/publications/list", :locals => { :search => params[:search] }
          end
        end
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def versions
    @publication = Publication.find(params[:id])
  end
  
  private
  
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