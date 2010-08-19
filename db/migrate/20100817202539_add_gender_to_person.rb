class AddGenderToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :gender, :string
    add_column :people, :title, :string
    add_column :people, :fax, :string
    add_column :people, :address, :string
  end

  def self.down
    remove_column :people, :address
    remove_column :people, :fax
    remove_column :people, :title
    remove_column :people, :gender
  end
end