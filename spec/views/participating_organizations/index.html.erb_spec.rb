require 'spec_helper'

describe "/participating_organizations/index.html.erb" do
  include ParticipatingOrganizationsHelper

  before(:each) do
    assigns[:participating_organizations] = [
      stub_model(ParticipatingOrganization,
        :name => "value for name",
        :city => "value for city",
        :country_id => 1,
        :us_state_id => 1,
        :reporting_year => 1
      ),
      stub_model(ParticipatingOrganization,
        :name => "value for name",
        :city => "value for city",
        :country_id => 1,
        :us_state_id => 1,
        :reporting_year => 1
      )
    ]
  end

  it "renders a list of participating_organizations" do
    render
    response.should have_tag("tr>td", "value for name".to_s, 2)
    response.should have_tag("tr>td", "value for city".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end
