require 'spec_helper'

describe "/service_lines/new.html.haml" do
  include ServiceLinesHelper

  before(:each) do
    login(user_login)
    assigns[:user_organizational_units] = []
    assigns[:service_line] = stub_model(ServiceLine,
      :new_record? => true,
      :name => "value for name"
    )
  end

  it "renders new service_line form" do
    render
    response.should have_tag("form[action=?][method=post]", service_lines_path) do
      with_tag("input#service_line_name[name=?]", "service_line[name]")
      # with_tag("select#service_line_organizational_services_attributes_0_organizational_unit_id[name=?]", "service_line[organizational_services_attributes][0][organizational_unit_id]")
    end
  end
end
