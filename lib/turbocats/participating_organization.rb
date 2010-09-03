class Turbocats::ParticipatingOrganization < Turbocats::Base
  set_table_name 'participating_organizations'
  set_primary_key 'id'
  
  acts_as_importable
  
  # Turbocats
  #  name, city, country_name, us_state, reporting_year
  # 
  # ClearCats
  # name, city, country, us_state, reporting_year
  def to_model
    ::ParticipatingOrganization.new do |p|
      p.name = self.name
      p.city = self.city
      p.reporting_year = self.reporting_year.blank? ? 2009 : self.reporting_year.to_i
      p.country  = Country.find_by_name(self.country_name)
      p.us_state = UsState.find_by_abbreviation(self.us_state) 
    end
  end
end