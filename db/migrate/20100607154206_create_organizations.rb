class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :organizations do |t|
      t.string :type
      t.string :code
      t.string :name

      t.timestamps
    end
    
    add_index(:organizations, :type)
    add_index(:organizations, :code)
    add_index(:organizations, :name)
  end

  def self.down
    remove_index(:organizations, :type)
    remove_index(:organizations, :code)
    remove_index(:organizations, :name)
    drop_table :organizations
  end
end
