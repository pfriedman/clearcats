# == Schema Information
# Schema version: 20100817202539
#
# Table name: publications
#
#  id                   :integer         not null, primary key
#  pmcid                :string(255)
#  pmid                 :string(255)
#  nihms_number         :string(255)
#  publication_date     :date
#  person_id            :integer
#  abstract             :text
#  title                :string(1000)
#  nucats_assisted      :boolean
#  created_at           :datetime
#  updated_at           :datetime
#  cited                :boolean
#  missing_pmcid_reason :string(255)
#  reporting_year       :integer
#

# TurboCATS             ClearCATS
# pubmed_id             pmcid

# Same
#  person_id
#  cited
#  missing_pmcid_reason
#  reporting_year

# TurboCATS only
#  manuscript_id        :integer
#  invalid              :boolean
#  validation_messages  :text

class Publication < ActiveRecord::Base
  belongs_to :person
  
  named_scope :all_for_reporting_year, lambda { |yr| { :conditions => ["reporting_year = ?", yr ] } }

  # Attributes from LatticeGrid/PubMed
  attr_accessor :endnote_citation, :authors, :full_authors, :is_first_author_investigator, :is_last_author_investigator
  attr_accessor :journal_abbreviation, :journal, :volume, :issue, :pages, :year, :publication_type, :electronic_publication_date
  attr_accessor :deposited_date, :status, :publication_status, :issn, :isbn, :citation_cnt, :citation_last_get_at, :citation_url, :url, :mesh
  attr_accessor :created_id, :created_ip, :created_at, :updated_id, :updated_ip, :updated_at, :deleted_at, :deleted_id, :deleted_ip
  
  def pubmed=(pubmed)
    self.pmid = pubmed
  end
  
  def pubmed
    self.pmid
  end
  
  def formatted_publication_date
    self.publication_date.strftime("%m/%d/%Y") unless self.project_period_start_date.nil?
  end

  def formatted_publication_date=(dt)
    self.publication_date = dt
  end

  def pubmed_id
    self.pmcid
  end

  # TODO: determine attribute to base cited on :citation_cnt OR :citation_last_get_at OR ...
  def citation_cnt=(cnt)
    @citation_cnt = cnt
    self.cited = cnt.to_i > 0
  end
  
  def citation_cnt
    @citation_cnt
  end
  
end
