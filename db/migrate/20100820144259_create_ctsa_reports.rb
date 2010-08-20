class CreateCtsaReports < ActiveRecord::Migration
  def self.up
    create_table :ctsa_reports do |t|
      t.integer :created_by_id
      t.boolean :finalized
      t.boolean :has_errors
      t.integer :reporting_year
      t.string  :grant_number

      t.timestamps
    end
  end

  def self.down
    drop_table :ctsa_reports
  end
end
