# == Schema Information
# Schema version: 20101026151305
#
# Table name: services
#
#  id              :integer         not null, primary key
#  service_line_id :integer
#  person_id       :integer
#  created_by_id   :integer
#  entered_on      :date
#  state           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe Service do

  it "should create a new instance given valid attributes" do
    Factory(:service)
  end
  
  it "should describe itself in human readable format" do
    svc = Factory(:service)
    svc.to_s.should == "#{svc.organizational_unit.to_s} service line name"
  end
    
  it { should belong_to(:created_by) }
  
  context "state" do
  
    it "should start in the new state" do
      svc = Factory(:service, :person => nil, :service_line => nil)
      svc.should be_new
    end
    
    context "transitioning from new" do
      
      before(:each) do
        @svc = Factory(:service, :person => nil, :service_line => nil) 
        @svc.should be_new
        @person   = Factory(:person)
        @svc_line = Factory(:service_line)
      end
    
      it "should transition into the choose_service_line state after assigned to a person" do
        @svc.person = @person
        @svc.save!
        @svc.should be_choose_service_line
      end
    
      it "should transition into the choose_person state after assigned to a service line" do
        @svc.service_line = @svc_line
        @svc.save!      
        @svc.should be_choose_person
      end
      
      it "should become 'initiatied' once a person and service line are set" do
        @svc.service_line = @svc_line
        @svc.save!
        @svc.should be_choose_person
        
        @svc.person = @person
        @svc.save!
        @svc.should be_initiated
      end
      
      it "should become 'initiatied' once a person and service line are set" do
        @svc.person = @person
        @svc.save!
        @svc.should be_choose_service_line

        @svc.person.service_rendered.should == false

        @svc.service_line = @svc_line
        @svc.save!
        @svc.should be_initiated
        
        @svc.person.service_rendered.should == true
      end
      
    end
    
    context "transitioning from a post initiated state" do
      
      it "should not be able to become 'uninitiated' after being initiated" do
        svc = Factory(:service)
        svc.should be_initiated
        
        svc.person = nil
        svc.save!
        
        svc.should be_initiated
        svc.person.should_not be_nil
        
        svc.service_line = nil
        svc.save!

        svc.should be_initiated
        svc.service_line.should_not be_nil
      end
    
      it "should know the order (if any)"
      
    end
    
    it "should know all the possible states" do
      Service.state_machine.states.length.should == 10
      states = Service.state_machine.states.keys
      states.include?(:new).should be_true
      states.include?(:choose_person).should be_true
      states.include?(:choose_service_line).should be_true
      states.include?(:initiated).should be_true
      states.include?(:identified).should be_true
      states.include?(:choose_awards).should be_true
      states.include?(:choose_publications).should be_true
      states.include?(:choose_approvals).should be_true
      states.include?(:choose_organizational_units).should be_true
      states.include?(:surveyable).should be_true
      
      states.include?(:asdf).should_not be_true
    end
    
    
  end

end
