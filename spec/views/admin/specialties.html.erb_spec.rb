require 'spec_helper'

describe "/admin/specialties.html.erb" do

  context "with a logged in admin user" do
    before(:each) do
      login(admin_login)
      assigns[:search] = Specialty.search
      @specialty = Factory.create(:specialty)
      arr = [@specialty]
      assigns[:ctsa_data] = WillPaginate::Collection.create(1, 10) do |pager|
        pager.replace(arr)
        unless pager.total_entries
          pager.total_entries = arr.size
        end
      end
      
    end
    
    it "should render a list of specialties" do
      render
      response.should have_tag("table.records")
      response.should have_tag("table.records>tr.even_record>td", @specialty.code)
    end
    
  end
  
end
