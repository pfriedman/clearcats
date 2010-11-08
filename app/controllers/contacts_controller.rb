class ContactsController < ApplicationController
  before_filter :set_user_organizational_units
  
  def index
    params[:search] ||= {}
    params[:search][:organizational_units_id_eq_any] = @user_organizational_units.collect(&:id) unless @user_organizational_units.blank?
    
    @search = Contact.search(params[:search])
    @contacts = @search.paginate(:select => "distinct contacts.*", :page => params[:page], :per_page => 20)
  end
  
  def new
    @contact = Contact.new

    respond_to do |format|
      format.html
      format.xml  { render :xml => @contact }
    end
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.organizational_units << @user_organizational_units.first if @user_organizational_units.size == 1 and !@contact.organizational_units.include?(@user_organizational_units.first)

    respond_to do |format|
      if @contact.save
        flash[:notice] = 'Contact was successfully created.'
        format.html { redirect_to(contacts_path) }
        format.xml  { render :xml => @contact, :status => :created, :location => @contact }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
    @contact = Contact.find(params[:id])
  end

  def update
    @contact = Contact.find(params[:id])
    @contact.organizational_units << @user_organizational_units.first if @user_organizational_units.size == 1 and !@contact.organizational_units.include?(@user_organizational_units.first)
    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        flash[:notice] = 'Contact was successfully updated.'
        format.html { redirect_to(contacts_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to(contacts_url) }
      format.xml  { head :ok }
    end
  end

  private 
  
    def set_user_organizational_units
      @user_organizational_units = determine_org_units_for_user
    end
  
end