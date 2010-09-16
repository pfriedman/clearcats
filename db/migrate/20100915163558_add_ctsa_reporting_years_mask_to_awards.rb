class AddCtsaReportingYearsMaskToAwards < ActiveRecord::Migration
  def self.up
    add_column :awards, :ctsa_reporting_years_mask, :integer
    remove_column :awards, :years_of_award
    
    add_column :publications, :ctsa_reporting_years_mask, :integer
    remove_column :publications, :reporting_year
  end

  def self.down
    remove_column :publications, :ctsa_reporting_years_mask
    add_column :publications, :reporting_year, :integer
    add_column :awards, :years_of_award, :string
    remove_column :awards, :ctsa_reporting_years_mask
  end
end