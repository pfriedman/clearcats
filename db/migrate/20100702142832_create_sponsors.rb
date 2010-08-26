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
    
    add_index(:sponsors, :name)
    add_index(:sponsors, :code)
    add_index(:awards, :sponsor_id)
    add_index(:awards, :originating_sponsor_id)
  end

  def self.down
    remove_index(:sponsors, :name)
    remove_index(:sponsors, :code)
    remove_index(:awards, :sponsor_id)
    remove_index(:awards, :originating_sponsor_id)
    
    remove_column :awards, :originating_sponsor_id
    remove_column :awards, :sponsor_id
    drop_table :sponsors
  end
end