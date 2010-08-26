class CreateSpecialties < ActiveRecord::Migration
  def self.up
    create_table :specialties do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
    add_index(:specialties, :code)
    add_index(:specialties, :name)
  end

  def self.down
    remove_index(:specialties, :name)
    remove_index(:specialties, :code)
    drop_table :specialties
  end
end
