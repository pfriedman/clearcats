class CreateParticipatingOrganizations < ActiveRecord::Migration
  def self.up
    create_table :participating_organizations do |t|
      t.string :name
      t.string :city
      t.integer :country_id
      t.integer :us_state_id
      t.integer :reporting_year

      t.timestamps
    end
  end

  def self.down
    drop_table :participating_organizations
  end
end
