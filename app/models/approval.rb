class Approval < ActiveRecord::Base

  TYPES = ["IRB", "IACUC", "IND", "IDE", "BLA", "NDA", "Patent", "Other", "Not Applicable"]
  
  validates_inclusion_of :approval_type, :in => Approval::TYPES

  belongs_to :person

end
