require 'spec_helper'

describe "/services/new.html.haml" do
  include ServicesHelper

  before(:each) do
    login(user_login)
    assigns[:pending_services] = []
    assigns[:service] = stub_model(Service, :new_record? => true)
  end

  it "renders new service form" do
    render
    response.should have_tag("a[href=?]", choose_person_services_path)
    response.should have_tag("a[href=?]", choose_service_line_services_path)
  end
end