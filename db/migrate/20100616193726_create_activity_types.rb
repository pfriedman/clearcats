class CreateActivityTypes < ActiveRecord::Migration
  def self.up
    create_table :activity_types do |t|
      t.string :name
      t.integer :service_line_id

      t.timestamps
    end
    add_index(:activity_types, :service_line_id)
    add_index(:activity_types, :name)
  end

  def self.down
    remove_index(:activity_types, :name)
    remove_index(:activity_types, :service_line_id)
    drop_table :activity_types
  end
end