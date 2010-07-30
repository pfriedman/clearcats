# == Schema Information
# Schema version: 20100727181206
#
# Table name: publications
#
#  id               :integer         not null, primary key
#  pmcid            :string(255)
#  pmid             :string(255)
#  nihms_number     :string(255)
#  publication_date :date
#  person_id        :integer
#  abstract         :text
#  title            :string(1000)
#  nucats_assisted  :boolean
#  created_at       :datetime
#  updated_at       :datetime
#

class Publication < ActiveRecord::Base
  belongs_to :person

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

end
