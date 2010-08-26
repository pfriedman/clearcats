class CreateActivityCodes < ActiveRecord::Migration
  def self.up
    create_table :activity_codes do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
    
    add_index(:activity_codes, :code)
    add_index(:activity_codes, :name)
  end

  def self.down
    remove_index(:activity_codes, :name)
    remove_index(:activity_codes, :code)
    drop_table :activity_codes
  end
end
