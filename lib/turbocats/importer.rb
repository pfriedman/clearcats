class Turbocats::Importer
  def self.run
    Turbocats::Person.each do |legacy_model|
      legacy_model.import if ::Person.first(:conditions => ["UPPER(era_commons_username) = ?", legacy_model.commons_username.upcase]).nil?
    end
    
    Client.all.each do |client| 
      FacultyWebService.locate({:employeeid => client.employeeid}, true) unless client.employeeid.blank?
    end
    
    Client.all.each do |client| 
      FacultyWebService.awards_for_employee({:employeeid => client.employeeid}) unless client.employeeid.blank?
      LatticeGridWebService.investigator_publications_search(client.netid) unless client.netid.blank?
    end
    
    Turbocats::PhsFunding.import_all
    Turbocats::NonPhsFunding.import_all
    Turbocats::ParticipatingOrganization.import_all
    
    # Flush all the lookup tables
    Turbocats::Person.flush_lookups!
    Turbocats::PhsFunding.flush_lookups!
    Turbocats::NonPhsFunding.flush_lookups!
    Turbocats::ParticipatingOrganization.flush_lookups!
  end
end