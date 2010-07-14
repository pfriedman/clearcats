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
    
    # add_column :users, :organizational_unit_id, :integer
  end

  def self.down
    # remove_column :users, :organizational_unit_id
    drop_table :organizational_units
  end
end