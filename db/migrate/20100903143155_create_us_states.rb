class CreateUsStates < ActiveRecord::Migration
  def self.up
    create_table :us_states do |t|
      t.string :name
      t.string :abbreviation

      t.timestamps
    end
  end

  def self.down
    drop_table :us_states
  end
end
