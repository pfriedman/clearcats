class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :company_name
      t.integer :person_id

      t.timestamps
    end
    add_index(:contacts, :email)
    
    create_table :contacts_organizational_units, :id => false do |t|
      t.integer :organizational_unit_id
      t.integer :contact_id
    end
    
    add_index(:contacts_organizational_units, [:contact_id, :organizational_unit_id], :name => "contacts_organizational_units_idx")
    
  end

  def self.down
    remove_index(:contacts, :email)
    drop_table :contacts_organizational_units
    drop_table :contacts
  end
end
