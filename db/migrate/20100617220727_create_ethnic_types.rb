class CreateEthnicTypes < ActiveRecord::Migration
  def self.up
    create_table :ethnic_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :ethnic_types
  end
end
