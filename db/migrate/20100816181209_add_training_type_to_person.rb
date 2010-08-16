class AddTrainingTypeToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :training_type, :string
    add_column :people, :appointed_trainee, :boolean
  end

  def self.down
    remove_column :people, :appointed_trainee
    remove_column :people, :training_type
  end
end