require 'spec_helper'

describe "/participating_organizations/show.html.erb" do
  include ParticipatingOrganizationsHelper
  before(:each) do
    assigns[:participating_organization] = @participating_organization = stub_model(ParticipatingOrganization,
      :name => "value for name",
      :city => "value for city",
      :country_id => 1,
      :us_state_id => 1,
      :reporting_year => 1
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ city/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
  end
end
