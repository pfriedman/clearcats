class AddCtsaReportingYearsMaskToAwards < ActiveRecord::Migration
  def self.up
    add_column :awards, :ctsa_reporting_years_mask, :integer
    remove_column :awards, :years_of_award
  end

  def self.down
    add_column :awards, :years_of_award, :string
    remove_column :awards, :ctsa_reporting_years_mask
  end
end
