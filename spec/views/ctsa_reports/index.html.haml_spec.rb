require 'spec_helper'

describe "/ctsa_reports/index.html.haml" do
  include CtsaReportsHelper

  before(:each) do
    @ctsa_report = Factory(:ctsa_report)
    assigns[:ctsa_reports] = will_paginate_collection([@ctsa_report])
  end

  it "renders a list of ctsa_reports" do
    render
    response.should have_tag("tr>td", @ctsa_report.created_by.to_s, 1)
    response.should have_tag("tr>td", "False", 1)
    response.should have_tag("tr>td", "False", 1)
    response.should have_tag("tr>td", @ctsa_report.reporting_year.to_s, 1)
  end
end
