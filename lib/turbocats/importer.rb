class Turbocats::Importer
  def self.run
    Turbocats::Person.import_all
    Turbocats::PhsFunding.import_all
    Turbocats::NonPhsFunding.import_all
    
    # Flush all the lookup tables
    Turbocats::Person.flush_lookups!
    Turbocats::PhsFunding.flush_lookups!
    Turbocats::NonPhsFunding.flush_lookups!
  end
end