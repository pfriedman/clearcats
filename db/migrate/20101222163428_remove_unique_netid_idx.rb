class RemoveUniqueNetidIdx < ActiveRecord::Migration
  def self.up
    execute "DROP INDEX people_netid_idx;"
  end

  def self.down
    add_index(:people, :netid, :unique => true, :name => 'people_netid_idx')
  end
end
