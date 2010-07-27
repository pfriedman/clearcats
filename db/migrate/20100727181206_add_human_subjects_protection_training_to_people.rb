class AddHumanSubjectsProtectionTrainingToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :human_subject_protection_training_institution, :string
    add_column :people, :human_subject_protection_training_date, :date
  end

  def self.down
    remove_column :people, :human_subject_protection_training_institution
    remove_column :people, :human_subject_protection_training_date
  end
end