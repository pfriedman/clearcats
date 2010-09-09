# == Schema Information
# Schema version: 20100903173011
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

require "state_machine"
class Service < ActiveRecord::Base
  
  belongs_to :service_line
  belongs_to :person
  belongs_to :created_by, :class_name => "User", :foreign_key => :created_by_id
  
  delegate :organizational_unit, :to => :service_line
  
  state_machine :state, :initial => :new do
    event :set_service_line do
      transition [:new, :choose_service_line] => :choose_person
    end

    event :identify do
      transition [:new, :choose_person] => :choose_service_line
    end

    event :initiate do
      transition [:choose_service_line, :choose_person] => :initiated
    end

    event :project_approvals_chosen do
      transition [:choose_approvals] => :choose_organizational_units
    end
    
    state :new
    state :choose_person
    state :choose_service_line
    state :initiated
    state :identified
    state :choose_awards
    state :choose_publications
    state :choose_approvals
    state :choose_organizational_units
  end
  
  def initialize(attributes = nil)
    super(attributes) # NOTE: This *must* be called, otherwise states won't get initialized
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
    "#{self.service_line.organizational_unit.to_s} #{self.service_line}".strip #  [#{self.updated_at}]
  end

end
