class CreateDepartments < ActiveRecord::Migration
  def self.up
    create_table :departments do |t|
      t.string :name 
      t.integer :externalid
      t.string :entity_name
      t.string :school

      t.timestamps
    end
    add_index(:departments, :name)
    add_index(:departments, :externalid)
  end

  def self.down
    remove_index(:departments, :name)
    remove_index(:departments, :externalid)
    drop_table :departments
  end
end
