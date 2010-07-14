class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :organizations do |t|
      t.string :type
      t.string :code
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :organizations
  end
end
