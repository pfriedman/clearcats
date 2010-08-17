class AddCitedAndMissingPmcidReasonToPublication < ActiveRecord::Migration
  def self.up
    add_column :publications, :cited, :boolean
    add_column :publications, :missing_pmcid_reason, :string
    add_column :publications, :reporting_year, :integer
  end

  def self.down
    remove_column :publications, :reporting_year
    remove_column :publications, :missing_pmcid_reason
    remove_column :publications, :cited
  end
end