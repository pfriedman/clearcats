class AddTrainingTypeToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :training_type, :string
    add_column :people, :trainee_status, :string    
    add_column :people, :has_disability, :boolean
  end

  def self.down
    remove_column :people, :has_disability
    remove_column :people, :trainee_status
    remove_column :people, :training_type
  end
end