
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProtocolReader do
  
  before(:each) do
    @reader = ProtocolReader.new(File.expand_path(File.dirname(__FILE__) + '/../data/rsp_apr.xml'))
  end
  
  it "should extract email addresses from a given clinical trials.gov xml file" do
    
    emails = @reader.extract_emails
    emails.should_not be_empty
    emails.first.should == "g-jr@northwestern.edu"
  end

end
