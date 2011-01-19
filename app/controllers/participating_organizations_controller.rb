class ParticipatingOrganizationsController < ApplicationController
  # GET /participating_organizations
  # GET /participating_organizations.xml
  def index
    params[:search]         ||= Hash.new
    params[:search][:order] ||= "ascend_by_name"
    @search = ParticipatingOrganization.search(params[:search])
    @participating_organizations = @search.paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @participating_organizations }
    end
  end

  # GET /participating_organizations/1
  # GET /participating_organizations/1.xml
  def show
    @participating_organization = ParticipatingOrganization.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @participating_organization }
    end
  end

  # GET /participating_organizations/new
  # GET /participating_organizations/new.xml
  def new
    @participating_organization = ParticipatingOrganization.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @participating_organization }
    end
  end

  # GET /participating_organizations/1/edit
  def edit
    @participating_organization = ParticipatingOrganization.find(params[:id])
  end

  # POST /participating_organizations
  # POST /participating_organizations.xml
  def create
    @participating_organization = ParticipatingOrganization.new(params[:participating_organization])

    respond_to do |format|
      if @participating_organization.save
        format.html { redirect_to(edit_participating_organization_path(@participating_organization), :notice => 'Participating Organization was successfully created.') }
        format.xml  { render :xml => @participating_organization, :status => :created, :location => @participating_organization }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @participating_organization.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /participating_organizations/1
  # PUT /participating_organizations/1.xml
  def update
    @participating_organization = ParticipatingOrganization.find(params[:id])

    respond_to do |format|
      if @participating_organization.update_attributes(params[:participating_organization])
        format.html { redirect_to(edit_participating_organization_path(@participating_organization), :notice => 'Participating Organization was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @participating_organization.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /participating_organizations/1
  # DELETE /participating_organizations/1.xml
  def destroy
    @participating_organization = ParticipatingOrganization.find(params[:id])
    @participating_organization.destroy

    respond_to do |format|
      format.html { redirect_to(participating_organizations_url) }
      format.xml  { head :ok }
    end
  end
end
