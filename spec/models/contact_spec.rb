require 'spec_helper'

describe Contact do
  it "should create a new instance given valid attributes" do
    Factory(:contact)
  end
  
  it { should validate_presence_of(:email) }
  it { should have_and_belong_to_many(:organizational_units) }
  it { should belong_to(:person)}
  
  it "should reference the person whose email equals that of the contact" do
    email   = "asdf@asdf.asdf"
    person  = Factory(:person, :email => email)
    contact = Factory(:contact, :email => email)
    contact.person.should_not be_nil
    contact.person.should == person
  end
end
