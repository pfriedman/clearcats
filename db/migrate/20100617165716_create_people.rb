class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :netid
      t.string :email
      t.string :department_affiliation
      t.string :school_affiliation
      t.string :last_four_of_ssn
      t.string :phone
      t.string :era_commons_username
      t.string :employeeid
      t.integer :department_id

      # Personal background information for CTSA reporting
      t.integer :degree_type_one_id
      t.integer :degree_type_two_id
      t.integer :specialty_id
      t.integer :country_id      
      t.integer :ethnic_type_id
      t.integer :race_type_id
      t.boolean :disadvantaged_background

      t.timestamps
    end
    
    add_index(:people, :department_id)
    add_index(:people, :netid)
    add_index(:people, :era_commons_username)
    add_index(:people, :employeeid)
    add_index(:people, :degree_type_one_id)
    add_index(:people, :degree_type_two_id)
    add_index(:people, :specialty_id)
    add_index(:people, :country_id)
    add_index(:people, :ethnic_type_id)
    add_index(:people, :race_type_id)
    
    
    create_table :institution_positions_people, :id => false do |t|
      t.integer :institution_position_id
      t.integer :person_id
    end
    
    add_index(:institution_positions_people, [:institution_position_id, :person_id], :name => "institution_positions_people_idx")
    
    create_table :organizational_units_people, :id => false do |t|
      t.integer :organizational_unit_id
      t.integer :person_id
    end
    
    add_index(:organizational_units_people, [:organizational_unit_id, :person_id], :name => "organizational_units_people_idx")
    
  end

  def self.down
    remove_index(:people, :department_id)
    remove_index(:people, :netid)
    remove_index(:people, :era_commons_username)
    remove_index(:people, :employeeid)
    remove_index(:people, :degree_type_one_id)
    remove_index(:people, :degree_type_two_id)
    remove_index(:people, :specialty_id)
    remove_index(:people, :country_id)
    remove_index(:people, :ethnic_type_id)
    remove_index(:people, :race_type_id)
    remove_index(:institution_positions_people, :name => "institution_positions_people_idx")
    remove_index(:organizational_units_people, :name => "organizational_units_people_idx")
    drop_table :organizational_units_people
    drop_table :institution_positions_people
    drop_table :people
  end
end