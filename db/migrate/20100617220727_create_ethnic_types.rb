class CreateEthnicTypes < ActiveRecord::Migration
  def self.up
    create_table :ethnic_types do |t|
      t.string :name

      t.timestamps
    end
    
    add_index(:ethnic_types, :name)
  end

  def self.down
    remove_index(:ethnic_types, :name)
    drop_table :ethnic_types
  end
end
