class CreateContactLists < ActiveRecord::Migration
  def self.up
    create_table :contact_lists do |t|
      t.string :name
      t.integer :organizational_unit_id

      t.timestamps
    end
    
    create_table :contact_lists_contacts, :id => false do |t|
      t.integer :contact_id
      t.integer :contact_list_id
    end
    
    add_index(:contact_lists_contacts, [:contact_list_id, :contact_id], :name => "contact_lists_contacts_idx")
    
  end

  def self.down
    remove_index(:contact_lists_contacts, :name => "contact_lists_contacts_idx")
    drop_table :contact_lists_contacts
    drop_table :contact_lists
  end
end
