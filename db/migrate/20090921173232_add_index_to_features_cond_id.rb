class AddIndexToFeaturesCondId < ActiveRecord::Migration
  def self.up 
    add_index(:features, :gene_id)
    add_index(:features, :condition_id)
    add_index(:features, :data_type)
  end

  def self.down
    remove_index(:features, :gene_id)
    remove_index(:features, :condition_id)
    remove_index(:features, :data_type)
  end
end
