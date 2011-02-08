class AddJournalAndCitationCountToPublications < ActiveRecord::Migration
  def self.up
    add_column :publications, :journal, :string
    add_column :publications, :citation_cnt, :integer
  end

  def self.down
    remove_column :publications, :citation_cnt
    remove_column :publications, :journal
  end
end
