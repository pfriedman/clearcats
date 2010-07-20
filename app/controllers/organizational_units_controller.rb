class OrganizationalUnitsController < ApplicationController
  before_filter :ensure_admin
  # include Bcsec::Rails::SecuredController
  # permit :administrators
  
  # GET /organizational_units
  # GET /organizational_units.xml
  def index
    @search = OrganizationalUnit.search(params[:search])
    @organizational_units = @search.paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @organizational_units }
    end
  end

  # GET /organizational_units/1
  # GET /organizational_units/1.xml
  def show
    @organizational_unit = OrganizationalUnit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @organizational_unit }
    end
  end

  # GET /organizational_units/new
  # GET /organizational_units/new.xml
  def new
    @organizational_unit = OrganizationalUnit.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @organizational_unit }
    end
  end

  # GET /organizational_units/1/edit
  def edit
    @organizational_unit = OrganizationalUnit.find(params[:id])
  end

  # POST /organizational_units
  # POST /organizational_units.xml
  def create
    @organizational_unit = OrganizationalUnit.new(params[:organizational_unit])

    respond_to do |format|
      if @organizational_unit.save
        flash[:notice] = 'Organizational Unit was successfully created.'
        format.html { redirect_to(organizational_units_url) }
        format.xml  { render :xml => @organizational_unit, :status => :created, :location => @organizational_unit }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @organizational_unit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /organizational_units/1
  # PUT /organizational_units/1.xml
  def update
    @organizational_unit = OrganizationalUnit.find(params[:id])

    respond_to do |format|
      if @organizational_unit.update_attributes(params[:organizational_unit])
        flash[:notice] = 'Organizational Unit was successfully updated.'
        format.html { redirect_to(organizational_units_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @organizational_unit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /organizational_units/1
  # DELETE /organizational_units/1.xml
  def destroy
    @organizational_unit = OrganizationalUnit.find(params[:id])
    @organizational_unit.destroy

    respond_to do |format|
      format.html { redirect_to(organizational_units_url) }
      format.xml  { head :ok }
    end
  end
end
