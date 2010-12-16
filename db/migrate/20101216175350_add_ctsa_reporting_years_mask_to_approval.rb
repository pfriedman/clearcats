class AddCtsaReportingYearsMaskToApproval < ActiveRecord::Migration
  def self.up
    add_column :approvals, :ctsa_reporting_years_mask, :integer
  end

  def self.down
    remove_column :approvals, :ctsa_reporting_years_mask
  end
end
