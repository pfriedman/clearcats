class UpcaseEraCommonsName < ActiveRecord::Migration
  def self.up
    Person.all.each do |pers|
      pers.era_commons_username = pers.era_commons_username.upcase unless pers.era_commons_username.blank?
    end
  end

  def self.down
  end
end
