require 'spec_helper'

describe "/admin/activity_codes.html.haml" do

  context "with a logged in admin user" do
    before(:each) do
      login(admin_login)
      assigns[:search] = ActivityCode.search
      @activity_code = Factory.create(:activity_code)
      arr = [@activity_code]
      assigns[:ctsa_data] = WillPaginate::Collection.create(1, 10) do |pager|
        pager.replace(arr)
        unless pager.total_entries
          pager.total_entries = arr.size
        end
      end
      
    end
    
    it "should render a list of activity_codes" do
      render
      response.should have_tag("table.records")
      response.should have_tag("table.records>tr.even_record>td", @activity_code.code)
    end
    
  end
  
end
