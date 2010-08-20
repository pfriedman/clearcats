class CtsaReport < ActiveRecord::Base
  belongs_to :created_by, :class_name => "User", :foreign_key => "created_by_id"
  # has_many :attachments
end
