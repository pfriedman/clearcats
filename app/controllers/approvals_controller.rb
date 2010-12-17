class ApprovalsController < ApplicationController
  layout proc { |controller| controller.request.xhr? ? nil : 'application'  } 

  def index
    if params[:person_id]
      params[:search]           ||= Hash.new
      params[:search][:person_id] = params[:person_id]
      
      populate_service_and_person

      @search = Approval.search(@search_params)
      @publications = @search.all
    else
      flash[:notice] = "Approvals can be viewed only in the context of a person."
      redirect_to people_path
    end
  end
  
  def update_approvals
    attr_params = {}
    # Handle polymorphic person - params key dependent on person class
    [:person, :client, :user].each { |e| attr_params = attr_params.merge(params[e]) unless params[e].blank? }
    populate_service_and_person
    @person.update_attributes(attr_params)
    flash[:notice] = "Approvals updated."
    redirect_to :controller => "approvals", :action => "index", :person_id => @person.id
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