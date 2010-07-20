class CreateSponsors < ActiveRecord::Migration
  def self.up
    create_table :sponsors do |t|
      t.string :name
      t.string :code
      t.string :sponsor_type_description
      t.string :sponsor_type
      
      t.timestamps
    end
    
    add_column :awards, :sponsor_id, :integer
    add_column :awards, :originating_sponsor_id, :integer
    
  end

  def self.down
    remove_column :awards, :originating_sponsor_id
    remove_column :awards, :sponsor_id
    drop_table :sponsors
  end
end