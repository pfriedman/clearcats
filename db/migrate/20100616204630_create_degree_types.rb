class CreateDegreeTypes < ActiveRecord::Migration
  def self.up
    create_table :degree_types do |t|
      t.string :type
      t.string :name
      t.string :abbreviation

      t.timestamps
    end
    add_index(:degree_types, :type)
    add_index(:degree_types, :name)
  end

  def self.down
    remove_index(:degree_types, :type)
    remove_index(:degree_types, :name)
    drop_table :degree_types
  end
end
