require 'spec_helper'

describe "/admin/index.html.erb" do

  context "with a logged in admin user" do
    before(:each) do
      login(admin_login)
    end
    
    it "should render a list of administrative actions" do
      render

      response.should have_tag("h1", "Welcome to ClearCATS!")

      response.should have_tag("h3", "Administrative Actions")
      response.should have_tag("ul#administrative_actions")
      
      response.should have_tag("ul#administrative_actions>li:nth-child(1)>a", "Manage Users")
      response.should have_tag("ul#administrative_actions>li:nth-child(1)>a[href=/users]")
      
      response.should have_tag("ul#administrative_actions>li:nth-child(2)>a", "Manage Organizational Units")
      response.should have_tag("ul#administrative_actions>li:nth-child(2)>a[href=/organizational_units]")
      
      response.should have_tag("ul#administrative_actions>li:nth-child(3)>a", "Manage Service Lines")
      response.should have_tag("ul#administrative_actions>li:nth-child(3)>a[href=/service_lines]")
      
      response.should have_tag("ul#administrative_actions>li:nth-child(4)>a", "Upload CTSA Data")
      response.should have_tag("ul#administrative_actions>li:nth-child(4)>a[href=/admin/upload_ctsa_data]")
      
      response.should have_tag("ul#administrative_actions>li:nth-child(5)>a", "View CTSA Data")
      response.should have_tag("ul#administrative_actions>li:nth-child(5)>a[href=/admin/view_ctsa_data]")
    end
    
  end
  
end
