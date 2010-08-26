class CreateServices < ActiveRecord::Migration
  def self.up
    create_table :services do |t|
      t.integer :service_line_id
      t.integer :person_id
      t.integer :created_by_id
      t.date :entered_on
      t.string :state

      t.timestamps
    end
    add_index :services, :service_line_id
    add_index :services, :person_id
    add_index :services, :created_by_id
  end

  def self.down
    remove_index :services, :created_by_id
    remove_index :services, :person_id
    remove_index :services, :service_line_id
    drop_table :services
  end
end