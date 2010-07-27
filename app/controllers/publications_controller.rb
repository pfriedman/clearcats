class PublicationsController < ApplicationController

  # GET /publications/edit
  def edit
    params[:search] ||= Hash.new
    @service        = Service.find(params[:service_id]) if params[:service_id]
    @publication    = Publication.find(params[:id])
    respond_to do |format|
      format.js do
        @show_close_button = true
        render 'edit', :layout => nil 
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