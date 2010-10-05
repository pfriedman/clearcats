require 'spec_helper'

describe "/admin/index.html.haml" do

  context "with a logged in admin user" do
    before(:each) do
      login(admin_login)
    end
    
    it "should render a list of administrative actions" do
      render

      response.should have_tag("h1", "Welcome to ClearCATS!")

      response.should have_tag("h3", "Center Manager Actions")
      response.should have_tag("ul#administrative_actions")
      
      response.should have_tag("ul#administrative_actions>li:nth-child(1)>a", "Manage Users")
      response.should have_tag("ul#administrative_actions>li:nth-child(1)>a[href=/users]")

      response.should have_tag("ul#administrative_actions>li:nth-child(2)>a", "Upload CTSA Data")
      response.should have_tag("ul#administrative_actions>li:nth-child(2)>a[href=/admin/upload_ctsa_data]")

      response.should have_tag("ul#organizational_unit_administrator_actions")
      
      response.should have_tag("ul#organizational_unit_administrator_actions>li:nth-child(1)>a", "Manage Organizational Units")
      response.should have_tag("ul#organizational_unit_administrator_actions>li:nth-child(1)>a[href=/organizational_units]")
      
      response.should have_tag("ul#organizational_unit_administrator_actions>li:nth-child(2)>a", "Manage Service Lines")
      response.should have_tag("ul#organizational_unit_administrator_actions>li:nth-child(2)>a[href=/service_lines]")
      
      response.should have_tag("ul#organizational_unit_administrator_actions>li:nth-child(3)>a", "View CTSA Data")
      response.should have_tag("ul#organizational_unit_administrator_actions>li:nth-child(3)>a[href=/admin/view_ctsa_data]")
    end
    
  end
  
end
