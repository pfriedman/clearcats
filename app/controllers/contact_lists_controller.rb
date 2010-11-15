class ContactListsController < ApplicationController
  before_filter :set_user_organizational_units
  
  def index
    params[:search] ||= {}
    params[:search][:organizational_unit_id_eq_any] = @user_organizational_units.collect(&:id) unless @user_organizational_units.blank?
    
    @search = ContactList.search(params[:search])
    @contact_lists = @search.all
  end
  
  def new
    @contact_list = ContactList.new
    @contacts = @contact_list.contacts
    respond_to do |format|
      format.html
      format.xml  { render :xml => @contact_list }
    end
  end

  def create
    params[:contact_list] ||= {}
    @contact_list = ContactList.new(params[:contact_list])
    @contact_list.organizational_unit = @user_organizational_units.first if @user_organizational_units.size == 1
    @contacts = @contact_list.contacts

    respond_to do |format|
      if @contact_list.save
        flash[:notice] = 'Contact List was successfully created.'
        format.html { redirect_to(contact_lists_path) }
        format.xml  { render :xml => @contact_list, :status => :created, :location => @contact_list }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @contact_list.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
    @contact_list = ContactList.find(params[:id])
    @contacts = @contact_list.contacts
  end

  def update
    @contact_list = ContactList.find(params[:id])
    @contact_list.organizational_unit = @user_organizational_units.first if @user_organizational_units.size == 1
    @contacts = @contact_list.contacts

    respond_to do |format|
      if @contact_list.update_attributes(params[:contact_list])
        flash[:notice] = 'Contact List was successfully updated.'
        format.html { redirect_to(contact_lists_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @contact_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @contact_list = ContactList.find(params[:id])
    @contact_list.destroy

    respond_to do |format|
      format.html { redirect_to(contact_lists_url) }
      format.xml  { head :ok }
    end
  end

  private 
  
    def set_user_organizational_units
      @user_organizational_units = determine_org_units_for_user
    end
  
end