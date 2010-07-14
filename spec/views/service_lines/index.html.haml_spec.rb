require 'spec_helper'

describe "/service_lines/index.html.haml" do
  include ServiceLinesHelper

  before(:each) do
    @organizational_unit = Factory(:organizational_unit)
    assigns[:service_lines] = [
      stub_model(ServiceLine,
        :name => "value for name",
        :organizational_units => [@organizational_unit]
      ),
      stub_model(ServiceLine,
        :name => "value for name",
        :organizational_units => [@organizational_unit]
      )
    ]
  end

  it "renders a list of service_lines" do
    render
    response.should have_tag("tr>td", "value for name".to_s, 2)
    response.should have_tag("tr>td", @organizational_unit.to_s, 2)
  end
end
