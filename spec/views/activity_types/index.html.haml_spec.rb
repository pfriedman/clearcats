require 'spec_helper'

describe "/activity_types/index.html.haml" do
  include ActivityTypesHelper

  before(:each) do
    @svc_line = Factory(:service_line)
    assigns[:activity_types] = [
      stub_model(ActivityType,
        :name => "value for name",
        :service_line_id => @svc_line.id
      ),
      stub_model(ActivityType,
        :name => "value for name",
        :service_line_id => @svc_line.id
      )
    ]
  end

  it "renders a list of activity_types" do
    render
    response.should have_tag("tr>td", "value for name".to_s, 2)
    response.should have_tag("tr>td", @svc_line.to_s, 2)
  end
end
