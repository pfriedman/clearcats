require 'message_helpers'
class CtsaReportsController < ApplicationController
  permit :Admin, :User
  
  # GET /ctsa_reports
  # GET /ctsa_reports.xml
  def index
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
    dir = "#{Rails.root}/tmp/ctsa_reports/"
    @ctsa_report_xml_file_path = create_xml_report(@ctsa_report, dir)

    respond_to do |format|
      # format.html
      format.zip
    end
    # zip_file = Zippy.create 'ctsa.zip' do |zip|
    #   zip["ctsa_report.xml"] = File.open(file_path)
    #   @ctsa_report.attachments.each do |doc|
    #     zip[doc.data_file_name] = File.open(doc.data.path)
    #   end
    # end
    # send_data(zip_file.data, :type => "application/zip", :filename => "ctsa_annual_report.zip")
  end
  
  private
  
    # Creates the xml for the ctsa report
    def create_xml_report(ctsa_report, dir)
      # TODO: check for valid ctsa report data
      file_path = "#{dir}/#{Time.now.to_i}.xml"
      org = OrganizationalUnit.find_by_abbreviation("NUCATS")
      doc = REXML::Document.new
      doc.add_element(ReportMessageHelper.new(ctsa_report.grant_number, ctsa_report.reporting_year, 
                      Person.all_investigators, Person.all_trainees, [org]))
      doc.write("",2)
      File.open(file_path, 'w') {|f| f.write(doc.to_s) }
      file_path
    end
end
