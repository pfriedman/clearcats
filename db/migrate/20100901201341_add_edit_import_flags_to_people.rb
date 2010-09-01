class AddEditImportFlagsToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :edited, :boolean
    add_column :people, :imported, :boolean
  end

  def self.down
    remove_column :people, :imported
    remove_column :people, :edited
  end
end