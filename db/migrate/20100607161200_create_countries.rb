class CreateCountries < ActiveRecord::Migration
  def self.up
    create_table :countries do |t|
      t.string :name

      t.timestamps
    end
    add_index(:countries, :name)
  end

  def self.down
    remove_index(:countries, :name)
    drop_table :countries
  end
end
