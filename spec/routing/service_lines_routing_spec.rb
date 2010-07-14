require 'spec_helper'

describe ServiceLinesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/service_lines" }.should route_to(:controller => "service_lines", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/service_lines/new" }.should route_to(:controller => "service_lines", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/service_lines/1" }.should route_to(:controller => "service_lines", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/service_lines/1/edit" }.should route_to(:controller => "service_lines", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/service_lines" }.should route_to(:controller => "service_lines", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/service_lines/1" }.should route_to(:controller => "service_lines", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/service_lines/1" }.should route_to(:controller => "service_lines", :action => "destroy", :id => "1") 
    end
  end
end
