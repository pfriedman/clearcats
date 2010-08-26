class CreateOrganizationalUnits < ActiveRecord::Migration
  def self.up
    create_table :organizational_units do |t|
      t.string :name
      t.string :abbreviation
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      
      t.timestamps
    end

    add_index(:organizational_units, :parent_id)
    add_index(:organizational_units, :name)
  end

  def self.down
    remove_index(:organizational_units, :name)
    remove_index(:organizational_units, :parent_id)
    drop_table :organizational_units
  end
end