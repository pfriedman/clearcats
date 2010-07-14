require 'spec_helper'

describe OrganizationalUnitsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/organizational_units" }.should route_to(:controller => "organizational_units", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/organizational_units/new" }.should route_to(:controller => "organizational_units", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/organizational_units/1" }.should route_to(:controller => "organizational_units", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/organizational_units/1/edit" }.should route_to(:controller => "organizational_units", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/organizational_units" }.should route_to(:controller => "organizational_units", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/organizational_units/1" }.should route_to(:controller => "organizational_units", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/organizational_units/1" }.should route_to(:controller => "organizational_units", :action => "destroy", :id => "1") 
    end
  end
end
