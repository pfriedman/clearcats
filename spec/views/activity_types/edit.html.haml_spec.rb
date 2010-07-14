require 'spec_helper'

describe "/activity_types/edit.html.haml" do
  include ActivityTypesHelper

  before(:each) do
    assigns[:activity_type] = @activity_type = stub_model(ActivityType,
      :new_record? => false,
      :name => "value for name",
      :service_line_id => 1
    )
  end

  it "renders the edit activity_type form" do
    render

    response.should have_tag("form[action=#{activity_type_path(@activity_type)}][method=post]") do
      with_tag('input#activity_type_name[name=?]', "activity_type[name]")
      with_tag('input#activity_type_service_line_id[name=?]', "activity_type[service_line_id]")
    end
  end
end
