require 'spec_helper'

describe "/service_lines/show.html.haml" do
  include ServiceLinesHelper
  before(:each) do
    assigns[:service_line] = @service_line = Factory(:service_line)
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/#{@service_line.name}/)
  end
end
