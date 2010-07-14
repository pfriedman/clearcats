require 'spec_helper'

describe "/service_lines/edit.html.haml" do
  include ServiceLinesHelper

  before(:each) do
    login(user_login)
    
    assigns[:service_line] = @service_line = stub_model(ServiceLine,
      :new_record? => false,
      :name => "value for name",
      :organizational_unit_id => 1
    )
  end

  it "renders the edit service_line form" do
    render

    response.should have_tag("form[action=#{service_line_path(@service_line)}][method=post]") do
      with_tag('input#service_line_name[name=?]', "service_line[name]")
      # with_tag("select#service_line_organizational_services_attributes_0_organizational_unit_id[name=?]", "service_line[organizational_services_attributes][0][organizational_unit_id]")
    end
  end
end
