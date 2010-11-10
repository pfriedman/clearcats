class ContactListsController < ApplicationController
  before_filter :set_user_organizational_units
  
  def index
    params[:search] ||= {}
    params[:search][:organizational_unit_id_eq_any] = @user_organizational_units.collect(&:id) unless @user_organizational_units.blank?
    
    @search = ContactList.search(params[:search])
    @contact_lists = @search.all
  end

  private 
  
    def set_user_organizational_units
      @user_organizational_units = determine_org_units_for_user
    end
  
end