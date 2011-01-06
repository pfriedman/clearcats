# == Schema Information
# Schema version: 20101216175350
#
# Table name: services
#
#  id              :integer         not null, primary key
#  service_line_id :integer
#  person_id       :integer
#  entered_on      :date
#  state           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  created_by      :string(255)
#  updated_by      :string(255)
#

require "state_machine"
class Service < ActiveRecord::Base
  
  belongs_to :service_line
  belongs_to :person
  
  delegate :organizational_unit, :to => :service_line
  
  before_save :add_organizational_unit_to_person
  before_destroy :remove_organizational_unit_from_person
  
  named_scope :organizational_unit_id_equals, lambda { |id|  {:joins => :service_line, :conditions => ["service_lines.organizational_unit_id = :id", {:id => id} ]} }
  
  state_machine :state, :initial => :new do
    
    state :new
    state :choose_person
    state :choose_service_line
    state :initiated
    state :identified
    state :choose_awards
    state :choose_publications
    state :choose_approvals
    state :completed
    state :surveyable
    
    event :identify do
      transition [:new, :choose_person] => :choose_service_line
    end
    
    event :set_service_line do
      transition [:new, :choose_service_line] => :choose_person
    end

    event :start_service do
      transition [:identified] => [:choose_service_line, :choose_person]
    end

    event :initiate do
      transition [:choose_service_line, :choose_person] => :initiated
    end
    
    event :profiling do
      transition :initiated => :choose_awards, :choose_awards => :choose_publications, :choose_publications => :choose_approvals
    end

    event :complete do
      transition [:choose_approvals] => :completed
    end
    
    event :readied_for_survey do
      transition [:completed] => :surveyable
    end
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
        self.person.update_attribute(:service_rendered, true) if person and !person.service_rendered?
      end
    when "choose_service_line"
      if !self.service_line_id.blank?
        self.initiate!
        self.person.update_attribute(:service_rendered, true) if person and !person.service_rendered?
      end
    when "choose_approvals"
      self.project_approvals_chosen!
    end
  end
  
  def to_s
    "#{self.service_line.organizational_unit.to_s} #{self.service_line}".strip #  [#{self.updated_at}]
  end
  
  def add_organizational_unit_to_person
    if should_add_organizational_unit_to_person?
      self.person.organizational_units << self.service_line.organizational_unit 
      self.person.save!
    end
  end
  
  def remove_organizational_unit_from_person
    if should_remove_organizational_unit_from_person?
      self.person.organizational_units.delete(self.service_line.organizational_unit)
      self.person.save!
    end
  end
  
  private
  
    def should_add_organizational_unit_to_person?
      self.person and self.service_line and !service_line.organizational_unit.blank? and !self.person.organizational_units.include?(self.service_line.organizational_unit)
    end
    
    def should_remove_organizational_unit_from_person?
      self.person and self.service_line and only_person_association_to_organizational_unit_is_through_this_service?
    end
  
    def only_person_association_to_organizational_unit_is_through_this_service?
      svcs = self.person.services.all(:conditions => "services.service_line_id IS NOT NULL") 
      svcs.map(&:organizational_unit).select { |ou| ou.id == self.service_line.organizational_unit.id }.count == 1
    end

end
