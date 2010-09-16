class Turbocats::Importer
  def self.run
    Turbocats::Person.each do |legacy_model|
      legacy_model.import if ::Person.first(:conditions => ["UPPER(era_commons_username) = ?", legacy_model.commons_username.upcase]).nil?
    end
    
    Turbocats::PhsFunding.import_all
    Turbocats::NonPhsFunding.import_all
    Turbocats::ParticipatingOrganization.import_all
    # Turbocats::Publication.import_all
    
    Client.all.each do |client| 
      FacultyWebService.locate({:employeeid => client.employeeid}, true) unless client.employeeid.blank?
    end
    
    Client.all.each do |client| 
      FacultyWebService.awards_for_employee({:employeeid => client.employeeid}) unless client.employeeid.blank?
      LatticeGridWebService.investigator_publications_search(client.netid) unless client.netid.blank?
    end
    
    
    pmcid_map = Hash.new
    FasterCSV.foreach("#{Rails.root}/lib/turbocats/turbocats_publications.csv") do |row|
      pmcid_map[row[1]] = {:cited => row[0], :reporting_year => row[2]}
    end
    
    Publication.all.each do |pub|
      if pmcid_map[pub.pmcid]
        pub.cited = pmcid_map[pub.pmcid][:cited]
        pub.ctsa_reporting_years = [pmcid_map[pub.pmcid][:reporting_year]]
        pub.save
      end
    end
    
    # Flush all the lookup tables
    Turbocats::Person.flush_lookups!
    Turbocats::PhsFunding.flush_lookups!
    Turbocats::NonPhsFunding.flush_lookups!
    Turbocats::ParticipatingOrganization.flush_lookups!
    # Turbocats::Publication.flush_lookups!
  end
end