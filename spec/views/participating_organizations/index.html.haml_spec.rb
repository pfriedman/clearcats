require 'spec_helper'

describe "/participating_organizations/index.html.haml" do
  include ParticipatingOrganizationsHelper

  before(:each) do
    assigns[:search] = ParticipatingOrganization.search
    arr = [
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
    assigns[:participating_organizations] = will_paginate_collection(arr)
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
