class CreateRaceTypes < ActiveRecord::Migration
  def self.up
    create_table :race_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :race_types
  end
end
