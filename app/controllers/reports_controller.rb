class ReportsController < ApplicationController
  permit :Admin
  
  def index
  end

  def client_list
    params[:search] ||= Hash.new
    @user_organizational_units = determine_org_units_for_user
    @search = Client.search(params[:search])
    @clients = @search.paginate(:page => params[:page], :per_page => 20)
    respond_to do |format|
      format.html # index.html.erb
      format.csv { render :csv => @search.all }
    end
  end

end