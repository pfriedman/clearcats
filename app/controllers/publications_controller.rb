class PublicationsController < ApplicationController
  layout nil

  # GET /publications/edit
  def edit
    @search_params  = params[:search_params]
    @service        = Service.find(params[:service_id])
    @publication    = Publication.find(params[:id])
  end
  
  # POST /publications
  def update
    @search_params  = params[:search_params]
    @service        = Service.find(params[:service_id])
    @publication    = Publication.find(params[:id])
    respond_to do |format|
      if @publication.update_attributes(params[:publication])
        @publications = Publication.search(params[:search])
        format.js do
          render :update do |page|
            page.replace "publications",
              :partial => "/publications/list", :locals => { :service => @service, :publications => @publications, :person => @service.person, :search => params[:search] }
          end
        end
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
end