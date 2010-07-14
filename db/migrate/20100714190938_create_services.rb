class CreateServices < ActiveRecord::Migration
  def self.up
    create_table :services do |t|
      t.integer :service_line_id
      t.integer :person_id
      t.string :state

      t.timestamps
    end
  end

  def self.down
    drop_table :services
  end
end
