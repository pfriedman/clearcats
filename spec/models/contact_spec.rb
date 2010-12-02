# == Schema Information
# Schema version: 20101202161044
#
# Table name: contacts
#
#  id           :integer         not null, primary key
#  email        :string(255)
#  first_name   :string(255)
#  last_name    :string(255)
#  company_name :string(255)
#  person_id    :integer
#  created_at   :datetime
#  updated_at   :datetime
#  created_by   :string(255)
#  updated_by   :string(255)
#

require 'spec_helper'

describe Contact do
  it "should create a new instance given valid attributes" do
    Factory(:contact)
  end
  
  it { should validate_presence_of(:email) }
  it { should have_and_belong_to_many(:organizational_units) }
  it { should have_and_belong_to_many(:contact_lists) }
  it { should belong_to(:person)}
  
  it "should reference the person whose email equals that of the contact" do
    email   = "asdf@asdf.asdf"
    person  = Factory(:person, :email => email)
    contact = Factory(:contact, :email => email)
    contact.person.should_not be_nil
    contact.person.should == person
  end
  
  context "uploading csv" do
    
    before(:each) do
      @org_unit = Factory(:organizational_unit, :abbreviation => "NUCATS", :name => "Clinical and Translational Sciences Institute")
      Contact.count.should == 0
    end
    
    it "should process the given file" do
      @org_unit.contacts.size.should == 0
      
      Contact.import_data(File.open(File.expand_path(File.dirname(__FILE__) + '/../data/contact_upload.csv')), @org_unit)
      
      Contact.count.should == 13
      @org_unit.contacts.reload
      @org_unit.contacts.size.should == Contact.count
    end
  end
end
