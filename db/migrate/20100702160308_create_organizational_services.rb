class CreateOrganizationalServices < ActiveRecord::Migration
  def self.up
    create_table :organizational_services do |t|
      t.integer :service_line_id
      t.integer :organizational_unit_id

      t.timestamps
    end
    add_index :organizational_services, :service_line_id
    add_index :organizational_services, :organizational_unit_id
  end

  def self.down
    remove_index :organizational_services, :organizational_unit_id
    remove_index :organizational_services, :service_line_id
    mind
    drop_table :organizational_services
  end
end