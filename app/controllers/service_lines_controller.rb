class ServiceLinesController < ApplicationController
  permit :Admin
  
  # GET /service_lines
  # GET /service_lines.xml
  def index
    params[:search] ||= {}
    
    ids = current_user.group_memberships.collect(&:affiliate_ids).flatten.map(&:to_i)
    unless ids.blank?
      @user_organizational_units = OrganizationalUnit.find_by_affiliate_ids(ids) 
      params[:search][:organizational_unit_id_eq_any] = @user_organizational_units.collect(&:id)
    end
    
    @search = ServiceLine.search(params[:search])
    @service_lines = @search.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @service_lines }
    end
  end

  # GET /service_lines/1
  # GET /service_lines/1.xml
  def show
    @service_line = ServiceLine.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @service_line }
    end
  end

  # GET /service_lines/new
  # GET /service_lines/new.xml
  def new
    @service_line = ServiceLine.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @service_line }
    end
  end

  # GET /service_lines/1/edit
  def edit
    @service_line = ServiceLine.find(params[:id])
  end

  # POST /service_lines
  # POST /service_lines.xml
  def create
    @service_line = ServiceLine.new(params[:service_line])

    respond_to do |format|
      if @service_line.save
        flash[:notice] = 'Service Line was successfully created.'
        format.html { redirect_to(@service_line) }
        format.xml  { render :xml => @service_line, :status => :created, :location => @service_line }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @service_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /service_lines/1
  # PUT /service_lines/1.xml
  def update
    @service_line = ServiceLine.find(params[:id])

    respond_to do |format|
      if @service_line.update_attributes(params[:service_line])
        flash[:notice] = 'Service Line was successfully updated.'
        format.html { redirect_to(@service_line) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @service_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /service_lines/1
  # DELETE /service_lines/1.xml
  def destroy
    @service_line = ServiceLine.find(params[:id])
    @service_line.destroy

    respond_to do |format|
      format.html { redirect_to(service_lines_url) }
      format.xml  { head :ok }
    end
  end
end
