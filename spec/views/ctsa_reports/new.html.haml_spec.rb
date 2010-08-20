require 'spec_helper'

describe "/ctsa_reports/new.html.haml" do
  include CtsaReportsHelper

  before(:each) do
    assigns[:ctsa_report] = @ctsa_report = CtsaReport.new
  end

  it "renders new ctsa_report form" do
    render

    response.should have_tag("form[action=?][method=post]", ctsa_reports_path) do
      with_tag("input#ctsa_report_finalized[name=?]", "ctsa_report[finalized]")
      with_tag("input#ctsa_report_has_errors[name=?]", "ctsa_report[has_errors]")
      with_tag("input#ctsa_report_reporting_year[name=?]", "ctsa_report[reporting_year]")
    end
  end
end
