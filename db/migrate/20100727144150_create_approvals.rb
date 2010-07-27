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
  end

  def self.down
    drop_table :approvals
  end
end
