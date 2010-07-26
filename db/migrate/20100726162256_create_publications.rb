class CreatePublications < ActiveRecord::Migration
  def self.up
    create_table :publications do |t|
      t.string :pmcid
      t.string :pmid
      t.string :nihms_number
      t.date :publication_date
      t.integer :person_id
      t.text :abstract
      t.string :title, :limit => 1000

      t.timestamps
    end
  end

  def self.down
    drop_table :publications
  end
end
