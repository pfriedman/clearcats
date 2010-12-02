class RemoveCreatedById < ActiveRecord::Migration
  def self.up
    remove_index :services, :created_by_id
    remove_index :ctsa_reports, :created_by_id
    
    remove_column :services, :created_by_id
    remove_column :ctsa_reports, :created_by_id
    
    add_column :services, :created_by, :string
    add_column :ctsa_reports, :created_by, :string
  end

  def self.down
    remove_column :services, :created_by
    remove_column :ctsa_reports, :created_by
  end
end