require 'spec_helper'

describe "/participating_organizations/edit.html.erb" do
  include ParticipatingOrganizationsHelper

  before(:each) do
    assigns[:participating_organization] = @participating_organization = stub_model(ParticipatingOrganization,
      :new_record? => false,
      :name => "value for name",
      :city => "value for city",
      :country_id => 1,
      :us_state_id => 1,
      :reporting_year => 1
    )
  end

  it "renders the edit participating_organization form" do
    render

    response.should have_tag("form[action=#{participating_organization_path(@participating_organization)}][method=post]") do
      with_tag('input#participating_organization_name[name=?]', "participating_organization[name]")
      with_tag('input#participating_organization_city[name=?]', "participating_organization[city]")
      with_tag('input#participating_organization_country_id[name=?]', "participating_organization[country_id]")
      with_tag('input#participating_organization_us_state_id[name=?]', "participating_organization[us_state_id]")
      with_tag('input#participating_organization_reporting_year[name=?]', "participating_organization[reporting_year]")
    end
  end
end
