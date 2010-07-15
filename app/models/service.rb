# == Schema Information
# Schema version: 20100714190938
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

require "aasm"
class Service < ActiveRecord::Base
  include AASM
  
  belongs_to :service_line
  belongs_to :person
  belongs_to :created_by, :class_name => "User", :foreign_key => :created_by_id
  
  aasm_column :state
  
  aasm_initial_state :new
  
  aasm_state :new
  aasm_state :choose_person
  aasm_state :choose_service_line
  aasm_state :initiated
  
  aasm_event :set_service_line do
    transitions :to => :choose_person, :from => [:new, :choose_service_line]
  end
  
  aasm_event :identify do
    transitions :to => :choose_service_line, :from => [:new, :choose_person]
  end
  
  aasm_event :initiate do
    transitions :to => :initiated, :from => [:choose_service_line, :choose_person]
  end
  
  def update_state

    Rails.logger.debug("~~~ state = #{self.state}")

    case self.state
    when "new"
      self.set_service_line! unless self.service_line.blank?
      self.identify!         unless self.person.blank?
    when "choose_person"
      self.initiate!         unless self.person.blank?
    when "choose_service_line"
      self.initiate!         unless self.service_line.blank?
    end
  end

end
