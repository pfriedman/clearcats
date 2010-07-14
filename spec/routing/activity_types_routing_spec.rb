require 'spec_helper'

describe ActivityTypesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/activity_types" }.should route_to(:controller => "activity_types", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/activity_types/new" }.should route_to(:controller => "activity_types", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/activity_types/1" }.should route_to(:controller => "activity_types", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/activity_types/1/edit" }.should route_to(:controller => "activity_types", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/activity_types" }.should route_to(:controller => "activity_types", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/activity_types/1" }.should route_to(:controller => "activity_types", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/activity_types/1" }.should route_to(:controller => "activity_types", :action => "destroy", :id => "1") 
    end
  end
end
