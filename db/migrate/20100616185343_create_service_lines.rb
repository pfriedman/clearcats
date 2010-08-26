class CreateServiceLines < ActiveRecord::Migration
  def self.up
    create_table :service_lines do |t|
      t.string :name

      t.timestamps
    end
    
    add_index(:service_lines, :name)
  end

  def self.down
    remove_index(:service_lines, :name)
    drop_table :service_lines
  end
end
