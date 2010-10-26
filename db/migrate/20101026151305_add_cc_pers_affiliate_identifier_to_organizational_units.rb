class AddCcPersAffiliateIdentifierToOrganizationalUnits < ActiveRecord::Migration
  def self.up
    add_column :organizational_units, :cc_pers_affiliate_identifier, :string

    OrganizationalUnit.all.each { |ou| ou.update_attribute(:cc_pers_affiliate_identifier, ou.abbreviation) }
  end

  def self.down
    remove_column :organizational_units, :cc_pers_affiliate_identifier
  end
end
