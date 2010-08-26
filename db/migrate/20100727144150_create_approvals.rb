class CreateApprovals < ActiveRecord::Migration
  def self.up
    create_table :approvals do |t|
      t.string :tracking_number
      t.string :institution
      t.string :approval_type
      t.string :project_title
      t.string :approval_date
      t.boolean :nucats_assisted
      t.string :principal_investigator
      t.integer :person_id

      t.timestamps
    end
    add_index :approvals, :person_id
  end

  def self.down
    remove_index :approvals, :person_id
    drop_table :approvals
  end
end