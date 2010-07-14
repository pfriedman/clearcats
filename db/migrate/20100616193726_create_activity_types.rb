class CreateActivityTypes < ActiveRecord::Migration
  def self.up
    create_table :activity_types do |t|
      t.string :name
      t.integer :service_line_id

      t.timestamps
    end
    
    # add_column :activities, :activity_type_id, :integer
  end

  def self.down
    # remove_column :activities, :activity_type_id
    drop_table :activity_types
  end
end