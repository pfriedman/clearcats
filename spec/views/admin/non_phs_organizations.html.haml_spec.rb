require 'spec_helper'

describe "/admin/non_phs_organizations.html.haml" do

  context "with a logged in admin user" do
    before(:each) do
      login(admin_login)
      assigns[:search] = NonPhsOrganization.search
      @non_phs_organization = Factory.create(:non_phs_organization)
      assigns[:ctsa_data] = will_paginate_collection([@non_phs_organization])
    end
    
    it "should render a list of non_phs_organizations" do
      render
      response.should have_tag("table.records")
      response.should have_tag("table.records>tr.even_record>td", @non_phs_organization.code)
    end
    
  end
  
end
