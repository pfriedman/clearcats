class CtsaReportsController < ApplicationController
  permit :Admin, :User
  
  # GET /ctsa_reports
  # GET /ctsa_reports.xml
  def index
    @ctsa_reports = CtsaReport.all

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
        format.html { redirect_to(@ctsa_report, :notice => 'CtsaReport was successfully created.') }
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
        format.html { redirect_to(@ctsa_report, :notice => 'CtsaReport was successfully updated.') }
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
  
  private
  
    # This XML plus all attachments must be compressed into a zip file
    # and then uploaded to the CTSA
    # find the website on the wiki: (http://www.ctsawiki.org/wiki//x/ngCP)
    def create_xml_report(ctsa_report)
      # TODO: check for valid form
      org = OrganizationalUnit.find_by_abbreviation("NUCATS")

      doc = REXML::Document.new
      doc.add_element(ReportMessageHelper.new(ctsa_report.grant_number, ctsa_report.reporting_year, 
                      Person.all_investigators, Person.all_trainees, [org]))
      doc.write("",2)
      # TODO: create report - zip up directory with all attachments and xml below
      # send_data(doc.to_s, :type => "text/xml",:filename => "ctsa_annual_report.xml")
    end
end
