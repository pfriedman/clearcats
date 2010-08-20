class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.string  :name
      t.integer :reporting_year
      t.references :attachable, :polymorphic => true

      t.timestamps
    end
  end

  def self.down
    drop_table :attachments
  end
end
