class CreateActivityCodes < ActiveRecord::Migration
  def self.up
    create_table :activity_codes do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :activity_codes
  end
end
