require 'spec_helper'

describe "/activity_types/new.html.haml" do
  include ActivityTypesHelper

  before(:each) do
    assigns[:activity_type] = stub_model(ActivityType,
      :new_record? => true,
      :name => "value for name",
      :service_line_id => 1
    )
  end

  it "renders new activity_type form" do
    render

    response.should have_tag("form[action=?][method=post]", activity_types_path) do
      with_tag("input#activity_type_name[name=?]", "activity_type[name]")
      with_tag("input#activity_type_service_line_id[name=?]", "activity_type[service_line_id]")
    end
  end
end
