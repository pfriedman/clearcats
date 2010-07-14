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
  end
  
  create_table :institution_positions_people, :id => false do |t|
    t.integer :institution_position_id
    t.integer :person_id
  end

  def self.down
    drop_table :institution_positions_people
    drop_table :people
  end
end
