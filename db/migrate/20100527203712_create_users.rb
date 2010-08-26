class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string    :first_name
      t.string    :middle_name
      t.string    :last_name
      t.string    :title
      t.string    :business_phone
      t.string    :fax
      t.string    :email
      t.string    :username
      t.string    :nu_employeeid
      t.string    :personnelid
      
      t.string    :address
      t.string    :city
      t.string    :state
      t.string    :country
      
      t.integer   :organizational_unit_id

      t.timestamps
    end
    
    # adding username index
    add_index(:users, :username, :unique => true, :name => 'users_username_idx')
    add_index(:users, :organizational_unit_id)
  end

  def self.down
    remove_index(:users, :name => 'users_username_idx')
    remove_index(:users, :organizational_unit_id)
    drop_table :users
  end
end
