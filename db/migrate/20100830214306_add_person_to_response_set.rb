class AddPersonToResponseSet < ActiveRecord::Migration
  def self.up
    add_column :response_sets, :person_id, :integer
    add_column :response_sets, :service_line_id, :integer
  end

  def self.down
    remove_column :response_sets, :service_line_id
    remove_column :response_sets, :person_id
  end
end