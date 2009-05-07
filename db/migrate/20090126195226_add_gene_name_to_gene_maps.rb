class AddGeneNameToGeneMaps < ActiveRecord::Migration
  def self.up
    add_column :gene_to_position_maps, :gene_name, :string
  end

  def self.down
    remove_column :gene_to_position_maps, :gene_name
  end
end
