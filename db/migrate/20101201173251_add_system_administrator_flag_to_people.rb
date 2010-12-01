class AddSystemAdministratorFlagToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :system_administrator, :boolean, :default => false
  end

  def self.down
    remove_column :people, :system_administrator
  end
end
