class AddSpeciesIdToSequences < ActiveRecord::Migration
  def self.up         
    add_column :sequences, :species_id, :integer
  end

  def self.down
    remove_column :sequences, :species_id
  end
end
