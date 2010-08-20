require 'spec_helper'

describe CtsaReportsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/ctsa_reports" }.should route_to(:controller => "ctsa_reports", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/ctsa_reports/new" }.should route_to(:controller => "ctsa_reports", :action => "new")
    end

    it "recognizes and generates #edit" do
      { :get => "/ctsa_reports/1/edit" }.should route_to(:controller => "ctsa_reports", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/ctsa_reports" }.should route_to(:controller => "ctsa_reports", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/ctsa_reports/1" }.should route_to(:controller => "ctsa_reports", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/ctsa_reports/1" }.should route_to(:controller => "ctsa_reports", :action => "destroy", :id => "1") 
    end
  end
end
