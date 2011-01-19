require 'spec_helper'

describe "/participating_organizations/new.html.haml" do
  include ParticipatingOrganizationsHelper

  before(:each) do
    assigns[:participating_organization] = stub_model(ParticipatingOrganization,
      :new_record? => true,
      :name => "value for name",
      :city => "value for city",
      :country_id => 1,
      :us_state_id => 1,
      :reporting_year => 1
    )
  end

  it "renders new participating_organization form" do
    render

    response.should have_tag("form[action=?][method=post]", participating_organizations_path) do
      with_tag("input#participating_organization_name[name=?]", "participating_organization[name]")
      with_tag("input#participating_organization_city[name=?]", "participating_organization[city]")
      with_tag("select#participating_organization_country_id[name=?]", "participating_organization[country_id]")
      with_tag("select#participating_organization_us_state_id[name=?]", "participating_organization[us_state_id]")
    end
  end
end
