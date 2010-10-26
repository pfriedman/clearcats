class ReportsController < ApplicationController
  permit :Admin
  
  def index
  end

  def client_list
    # TODO: retrieve clients who are associated with org units
    #       also filter by selected org unit and paginate
  end

end