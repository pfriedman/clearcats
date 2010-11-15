class ContactsController < ApplicationController
  before_filter :set_user_organizational_units
  
  def index
    params[:search] ||= {}
    params[:search][:organizational_units_id_eq_any] = @user_organizational_units.collect(&:id) unless @user_organizational_units.blank?
    
    @search = Contact.search(params[:search])
    @contacts = @search.paginate(:select => "distinct contacts.*", :page => params[:page], :per_page => 20)
  end
  
  def load_contact
    render :partial => "/contacts/details", :locals => {:contact => Contact.find(params[:id])}
  end

  def email_search
    render :json => Contact.autocomplete_email(params[:term]).collect{ |c| {:value => c.id, :label => "#{c.email}"} }.sort { |a, b| a[:label].downcase <=> b[:label].downcase }
  end
  
  def new
    @contact = Contact.new

    respond_to do |format|
      format.html
      format.xml  { render :xml => @contact }
    end
  end
  
  def show
    @contact = Contact.find(params[:id])
    @ldap_record = Ldap.new.retrieve_entry_by_email(@contact.email)
  end

  def create
    params[:contact] ||= {}
    existing_contact = Contact.find_by_email(params[:contact][:email])
    @contact = Contact.new(params[:contact])
    if existing_contact.blank?
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
    else
      flash[:link_warning] = "Contact already exists. Click to edit <a href=#{edit_contact_path(existing_contact)}>#{existing_contact}</a>."
      render :action => "new"
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
      format.html { redirect_to(contacts_url(:search => params[:search], :page => params[:page])) }
      format.xml  { head :ok }
    end
  end

  def upload
    if request.post?
      org_unit = OrganizationalUnit.find(params[:organizational_unit_id]) unless params[:organizational_unit_id].blank?
      
      if params[:file].blank?
        flash.now[:warning] = "You must select a file to upload."
        render :action => "upload"
      elsif org_unit.blank?
        flash[:link_warning] = "You cannot upload contacts outside the context of an organizational unit. <br />Please Select an Organizational Unit."
        redirect_to upload_contacts_path
      else
        Contact.import_data(params[:file].open, org_unit)
        redirect_to contacts_path
      end
    end
  end

  def sample_upload_file
    csv_headers = "Email Address,First Name,Last Name,Company Name"
    send_data(csv_headers, :file_name => "sample_clearcats_investigator_upload_file.csv", :type => "text/csv")
  end

  private 
  
    def set_user_organizational_units
      @user_organizational_units = determine_org_units_for_user
    end
  
end