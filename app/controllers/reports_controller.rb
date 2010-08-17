require 'message_helpers'
class ReportsController < ApplicationController
  permit :Admin
  
  def index
  end
  
  def ctsa_annual_report
    if request.post?
      grant_number = params[:grant_number]
      yr = params[:reporting_year]
      # TODO: check for valid form 
      org = OrganizationalUnit.find_by_abbreviation("NUCATS")

      doc = REXML::Document.new
      doc.add_element(ReportMessageHelper.new(grant_number, yr, Person.all_investigators, Person.all_trainees, [org]))
      doc.write("",2)
      send_data(doc.to_s, :type => "text/xml",:filename => "ctsa_annual_report.xml")
    end
  end
end