class CreateRaceTypes < ActiveRecord::Migration
  def self.up
    create_table :race_types do |t|
      t.string :name

      t.timestamps
    end
    add_index(:race_types, :name)
  end

  def self.down
    remove_index(:race_types, :name)
    drop_table :race_types
  end
end
