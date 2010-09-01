class Turbocats::Importer
  def self.run
    Turbocats::Person.import_all

    # Flush all the lookup tables
    Turbocats::Person.flush_lookups!
  end
end