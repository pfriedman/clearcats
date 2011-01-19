class AddCtsaReportingYearsMaskToParticipatingOrganizations < ActiveRecord::Migration
  def self.up
    add_column :participating_organizations, :ctsa_reporting_years_mask, :integer
    
    ParticipatingOrganization.all.each do |org|
      org.ctsa_reporting_years = [org.reporting_year] if org.reporting_year
      org.save!
    end
    
  end

  def self.down
    remove_column :participating_organizations, :ctsa_reporting_years_mask
  end
end
