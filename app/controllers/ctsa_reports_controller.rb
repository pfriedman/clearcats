class CtsaReportsController < ApplicationController
  permit :Admin, :User
  
  # GET /ctsa_reports
  # GET /ctsa_reports.xml
  def index
    summary
    @search = CtsaReport.search(params[:search])
    @ctsa_reports = @search.paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ctsa_reports }
    end
  end

  # GET /ctsa_reports/new
  # GET /ctsa_reports/new.xml
  def new
    @ctsa_report = CtsaReport.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ctsa_report }
    end
  end

  # GET /ctsa_reports/1/edit
  def edit
    @ctsa_report = CtsaReport.find(params[:id])
  end

  # POST /ctsa_reports
  # POST /ctsa_reports.xml
  def create
    @ctsa_report = CtsaReport.new(params[:ctsa_report])

    respond_to do |format|
      if @ctsa_report.save
        format.html { redirect_to(ctsa_reports_url, :notice => 'CtsaReport was successfully created.') }
        format.xml  { render :xml => @ctsa_report, :status => :created, :location => @ctsa_report }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ctsa_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ctsa_reports/1
  # PUT /ctsa_reports/1.xml
  def update
    @ctsa_report = CtsaReport.find(params[:id])

    respond_to do |format|
      if @ctsa_report.update_attributes(params[:ctsa_report])
        format.html { redirect_to(ctsa_reports_url, :notice => 'CtsaReport was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ctsa_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ctsa_reports/1
  # DELETE /ctsa_reports/1.xml
  def destroy
    @ctsa_report = CtsaReport.find(params[:id])
    @ctsa_report.destroy

    respond_to do |format|
      format.html { redirect_to(ctsa_reports_url) }
      format.xml  { head :ok }
    end
  end
  
  # The CTSA report XML plus all attachments must be compressed into a zip file
  # and then uploaded to the CTSA
  # find the website on the wiki: (http://www.ctsawiki.org/wiki//x/ngCP)  
  def download
    @ctsa_report = CtsaReport.find(params[:id])
    @ctsa_report_xml_file_path = @ctsa_report.create_xml_report("#{Rails.root}/tmp/ctsa_reports/")
    zip_file = @ctsa_report.create_zip_file
    send_data(zip_file.data, :type => "application/zip", :filename => "ctsa_annual_report.zip")
  end
  
  def irb_iacuc_report
    @irbs   = Approval.search({:approval_type_eq => 'IRB',   :all_for_reporting_year => current_ctsa_reporting_year}).all
    @iacucs = Approval.search({:approval_type_eq => 'IACUC', :all_for_reporting_year => current_ctsa_reporting_year}).all
    
    render :action => "irb_iacuc_report", :layout => "ctsa_report"
  end
  
  def technology_transfer_report
    @inds = Approval.search({:approval_type_eq => 'IND', :all_for_reporting_year => current_ctsa_reporting_year}).all
    @blas = Approval.search({:approval_type_eq => 'BLA', :all_for_reporting_year => current_ctsa_reporting_year}).all
    @ides = Approval.search({:approval_type_eq => 'IDE', :all_for_reporting_year => current_ctsa_reporting_year}).all
    @ndas = Approval.search({:approval_type_eq => 'NDA', :all_for_reporting_year => current_ctsa_reporting_year}).all
    @patents = Approval.search({:approval_type_eq => 'Patent', :all_for_reporting_year => current_ctsa_reporting_year}).all
    @others = Approval.search({:approval_type_eq => 'Other', :all_for_reporting_year => current_ctsa_reporting_year}).all
    render :action => "technology_transfer_report", :layout => "ctsa_report"
  end

  private
    # Quickly show to the user the number of People, Awards, and Publications that have been marked 
    # as CTSA Reportable for this year (or the chosen year)
    def summary
      yr = current_ctsa_reporting_year
      @investigators = Person.for_reporting_year(yr)
      @awards        = Award.all_for_reporting_year(yr)
      @publications  = Publication.all_for_reporting_year(yr)
    end

end
