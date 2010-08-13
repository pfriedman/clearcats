class PeopleController < ApplicationController
  permit :Admin, :User

  def index
    params[:search] ||= {}
    @search = Person.search(params[:search])
    @people = @search.paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html # index.html.erb
      format.csv { render :csv => @search.all }
    end
  end

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