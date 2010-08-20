# == Schema Information
# Schema version: 20100820144259
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
  aasm_state :identified
  aasm_state :choose_awards
  aasm_state :choose_publications
  aasm_state :choose_approvals
  aasm_state :choose_organizational_units
  
  aasm_event :set_service_line do
    transitions :to => :choose_person, :from => [:new, :choose_service_line]
  end
  
  aasm_event :identify do
    transitions :to => :choose_service_line, :from => [:new, :choose_person]
  end
  
  aasm_event :initiate do
    transitions :to => :initiated, :from => [:choose_service_line, :choose_person]
  end
  
  aasm_event :project_approvals_chosen do
    transitions :to => :choose_organizational_units, :from => [:choose_approvals]
  end
  
  def person=(person)
    self.person_id = person.id if person
  end
  
  def person_id=(person_id)
    if person_id
      self.write_attribute(:person_id, person_id)
      update_state
    end    
  end
  
  def service_line=(service_line)
    self.service_line_id = service_line.id if service_line
  end
  
  def service_line_id=(service_line_id)
    if service_line_id
      self.write_attribute(:service_line_id, service_line_id)
      update_state
    end
  end
  
  def update_state
    
    Rails.logger.info("~~~ Service#update_state - [#{self.state}]")
    
    case self.state
    when "new", nil
      self.set_service_line! unless self.service_line_id.blank?
      self.identify!         unless self.person_id.blank?
    when "choose_person"
      if !self.person_id.blank?
        self.initiate!
        self.person.update_attribute(:service_rendered, true) unless person.service_rendered?
      end
    when "choose_service_line"
      if !self.service_line_id.blank?
        self.initiate!
        self.person.update_attribute(:service_rendered, true) unless person.service_rendered?
      end
    when "choose_approvals"
      self.project_approvals_chosen!
    end
  end
  
  def to_s
    "#{self.service_line.organizational_units.to_sentence} #{self.service_line}".strip #  [#{self.updated_at}]
  end

end
