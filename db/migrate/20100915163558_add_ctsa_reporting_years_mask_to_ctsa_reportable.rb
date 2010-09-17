class AddCtsaReportingYearsMaskToCtsaReportable < ActiveRecord::Migration
  def self.up
    add_column :people, :ctsa_reporting_years_mask, :integer
    
    add_column :awards, :ctsa_reporting_years_mask, :integer
    remove_column :awards, :years_of_award
    
    add_column :publications, :ctsa_reporting_years_mask, :integer
    remove_column :publications, :reporting_year
  end

  def self.down
    remove_column :people, :ctsa_reporting_years_mask
    
    remove_column :publications, :ctsa_reporting_years_mask
    add_column :publications, :reporting_year, :integer
    
    remove_column :awards, :ctsa_reporting_years_mask
    add_column :awards, :years_of_award, :string
  end
end