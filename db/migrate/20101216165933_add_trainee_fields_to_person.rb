class AddTraineeFieldsToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :mentor_era_commons_username, :string
    add_column :people, :appointment_date, :date
    add_column :people, :end_date, :date
  end

  def self.down
    remove_column :people, :end_date
    remove_column :people, :appointment_date
    remove_column :people, :mentor_era_commons_username
  end
end
