require 'spec_helper'

describe "/admin/upload_ctsa_data.html.haml" do

  context "with a logged in admin user" do
    before(:each) do
      login(admin_login)
      assigns[:attachment] = stub_model(Attachment)
    end
    
    it "should render a way to upload the file" do
      render

      response.should have_tag("h3", "Upload CTSA Data File")
      
      response.should have_tag("input#attachment_data")
    end
    
  end
  
end
