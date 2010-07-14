require 'spec_helper'

describe "/activity_types/show.html.haml" do
  include ActivityTypesHelper
  before(:each) do
    assigns[:activity_type] = @activity_type = stub_model(ActivityType,
      :name => "value for name",
      :service_line_id => 1
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ name/)
    response.should have_text(/1/)
  end
end
