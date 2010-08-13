class AddServiceRenderedToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :service_rendered, :boolean, :default => false
  end

  def self.down
    remove_column :people, :service_rendered
  end
end
