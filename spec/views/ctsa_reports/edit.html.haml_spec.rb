require 'spec_helper'

describe "/ctsa_reports/edit.html.haml" do
  include CtsaReportsHelper

  before(:each) do
    assigns[:ctsa_report] = @ctsa_report = Factory(:ctsa_report)
  end

  it "renders the edit ctsa_report form" do
    render

    response.should have_tag("form[action=#{ctsa_report_path(@ctsa_report)}][method=post]") do
      with_tag('input#ctsa_report_finalized[name=?]', "ctsa_report[finalized]")
      with_tag('input#ctsa_report_has_errors[name=?]', "ctsa_report[has_errors]")
      with_tag('input#ctsa_report_reporting_year[name=?]', "ctsa_report[reporting_year]")
    end
  end
end
