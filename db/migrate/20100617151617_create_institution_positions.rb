class CreateInstitutionPositions < ActiveRecord::Migration
  def self.up
    create_table :institution_positions do |t|
      t.string :name

      t.timestamps
    end
    add_index(:institution_positions, :name)
  end

  def self.down
    remove_index(:institution_positions, :name)
    drop_table :institution_positions
  end
end
