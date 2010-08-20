require 'spec_helper'

describe "/admin/specialties.html.haml" do

  context "with a logged in admin user" do
    before(:each) do
      login(admin_login)
      assigns[:search] = Specialty.search
      @specialty = Factory.create(:specialty)
      assigns[:ctsa_data] = will_paginate_collection([@specialty])
    end
    
    it "should render a list of specialties" do
      render
      response.should have_tag("table.records")
      response.should have_tag("table.records>tr.even_record>td", @specialty.code)
    end
    
  end
  
end
