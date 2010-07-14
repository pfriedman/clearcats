class CreateOrganizationalServices < ActiveRecord::Migration
  def self.up
    create_table :organizational_services do |t|
      t.integer :service_line_id
      t.integer :organizational_unit_id

      t.timestamps
    end
  end

  def self.down
    drop_table :organizational_services
  end
end
