# == Schema Information
# Schema version: 20100820144259
#
# Table name: ctsa_reports
#
#  id             :integer         not null, primary key
#  created_by_id  :integer
#  finalized      :boolean
#  has_errors     :boolean
#  reporting_year :integer
#  grant_number   :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class CtsaReport < ActiveRecord::Base
  belongs_to :created_by, :class_name => "User", :foreign_key => "created_by_id"
  has_many :documents, :as => :documentable
  accepts_nested_attributes_for :documents, :allow_destroy => true
end
