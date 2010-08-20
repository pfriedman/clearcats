require 'spec_helper'

describe "/admin/phs_organizations.html.haml" do

  context "with a logged in admin user" do
    before(:each) do
      login(admin_login)
      assigns[:search] = PhsOrganization.search
      @phs_organization = Factory.create(:phs_organization)
      assigns[:ctsa_data] = will_paginate_collection([@phs_organization])
    end
    
    it "should render a list of phs_organizations" do
      render
      response.should have_tag("table.records")
      response.should have_tag("table.records>tr.even_record>td", @phs_organization.code)
    end
    
  end
  
end
