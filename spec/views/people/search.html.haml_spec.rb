require 'spec_helper'

describe "/people/search.html.haml" do
  include PeopleHelper

  it "renders search fields" do
    render
    
    response.should have_tag("form[action=/people/search_results][method=post]") do
      with_tag('input#netid[name=?]', "netid")
      with_tag('input#last_name[name=?]', "last_name")
    end
  end
end