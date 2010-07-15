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
  end

  def self.down
    drop_table :services
  end
end
