class PeopleController < ApplicationController

  # GET /people/search
  def search
    @organizational_unit_id = params[:organizational_unit_id]
  end
  
  # POST /people/search_results
  def search_results
    @organizational_unit_id = params[:organizational_unit_id]
    @redirect_action = params[:redirect_action]
    @people = FacultyWebService.locate(params)
  end
  
end