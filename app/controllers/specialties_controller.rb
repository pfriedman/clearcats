class SpecialtiesController < ApplicationController
  
  def index
    q = "%#{params[:term].to_s.downcase}%"
    specialties  = Specialty.all( :conditions => ["lower(name) like ? or code like ?", q, q] )
    specialties  = specialties.map { |s| { :id => s.id, :label => s.to_s, :value => s.to_s } }
    @specialties = specialties.sort { |a, b| a[:label].downcase <=> b[:label].downcase }

    respond_to do |format|
      format.html
      format.json { render :json => @specialties }
    end
  end
  
end