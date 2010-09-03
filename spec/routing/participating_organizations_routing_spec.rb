require 'spec_helper'

describe ParticipatingOrganizationsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/participating_organizations" }.should route_to(:controller => "participating_organizations", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/participating_organizations/new" }.should route_to(:controller => "participating_organizations", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/participating_organizations/1" }.should route_to(:controller => "participating_organizations", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/participating_organizations/1/edit" }.should route_to(:controller => "participating_organizations", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/participating_organizations" }.should route_to(:controller => "participating_organizations", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/participating_organizations/1" }.should route_to(:controller => "participating_organizations", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/participating_organizations/1" }.should route_to(:controller => "participating_organizations", :action => "destroy", :id => "1") 
    end
  end
end
