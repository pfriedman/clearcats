require 'activesupport'
class Turbocats::Publication < Turbocats::Base
  set_table_name 'publications'
  set_primary_key 'id'
  
  acts_as_importable
  
  def to_s
    "[#{self.id}] #{self.pubmed_id}"
  end

  def to_model
    ::Publication.new do |p|
      p.imported             = true
      p.cited                = self.cited
      p.pmcid                = self.pubmed_id
      p.ctsa_reporting_years = self.ctsa_reporting_year
    end
  end

  def ctsa_reporting_year
    self.reporting_year.blank? ? [2009] : [self.reporting_year.to_i]
  end
end