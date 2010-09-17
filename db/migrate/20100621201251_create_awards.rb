class CreateAwards < ActiveRecord::Migration
  def self.up
    create_table :awards do |t|
      t.string :grant_number
      t.string :years_of_award
      t.string :grant_title, :limit => 2500
      t.float :grant_amount
      t.integer :person_id
      t.integer :investigator_id
      t.string :role
      
      t.string :parent_institution_number
      t.string :institution_number
      t.string :subproject_number
      t.string :ctsa_award_type_award_number
      
      t.date :project_period_start_date
      t.date :project_period_end_date
      t.float :project_period_total_cost
      t.float :total_project_cost
      
      t.integer :organization_id
      t.string  :organization_type
      t.integer :activity_code_id
      
      t.string :proposal_status
      t.string :award_status
      t.string :sponsor_award_number 
      
      t.boolean :nucats_assisted
      t.string :budget_identifier
      
      t.boolean :edited_by_user
      
      t.timestamps
    end

    create_table :award_details do |t|
      t.integer :award_id
      t.string :budget_period
      t.date :budget_period_start_date
      t.date :budget_period_end_date
      t.float :budget_period_direct_cost
      t.float :budget_period_direct_and_indirect_cost
      t.string :budget_number
      t.float :direct_amount
      t.float :indirect_amount
      t.float :total_amount
      t.timestamps
    end
    
    add_index(:award_details, :budget_number)
    add_index(:awards, :budget_identifier)
    add_index(:awards, :person_id)
    add_index(:awards, :investigator_id)
    add_index(:awards, :activity_code_id)
    add_index(:awards, [:organization_type, :organization_id])
  end

  def self.down
    drop_table :award_details
    remove_index(:award_details, :budget_number)
    remove_index(:awards, :budget_identifier)
    remove_index(:awards, :person_id)
    remove_index(:awards, :investigator_id)
    remove_index(:awards, :activity_code_id)
    remove_index(:awards, [:organization_type, :organization_id])
    drop_table :awards
  end
end