require 'spec_helper'

describe ContactsHelper do

  it "is included in the helper object" do
    included_modules = (class << helper; self; end).send :included_modules
    included_modules.should include(ContactsHelper)
  end

  context "deleting a contact" do
    
    it "should allow a user to delete if the user and contacts have the same org units" do
      ou = Factory(:organizational_unit)
      contact = Factory(:contact)
      contact.organizational_units << ou
      helper.can_destroy?(contact.organizational_units, [ou]).should == true
    end
    
    it "should not allow a user to delete if the contact belongs to more org units than the user" do
      ou = Factory(:organizational_unit, :name => "ou")
      ou2 = Factory(:organizational_unit, :name => "ou2")
      contact = Factory(:contact)
      contact.organizational_units << ou
      contact.organizational_units << ou2

      helper.can_destroy?(contact.organizational_units, [ou]).should == false
    end
    
    it "should allow a user to delete if the user belongs to all the contact's org units" do
      ou = Factory(:organizational_unit, :name => "ou")
      ou2 = Factory(:organizational_unit, :name => "ou2")
      ou3 = Factory(:organizational_unit, :name => "ou3")
      contact = Factory(:contact)
      contact.organizational_units << ou
      contact.organizational_units << ou2

      helper.can_destroy?(contact.organizational_units, [ou, ou2, ou3]).should == true
    end
    
  end
end
