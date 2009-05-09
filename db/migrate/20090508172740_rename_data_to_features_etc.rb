class RenameDataToFeaturesEtc < ActiveRecord::Migration
  def self.up
    rename_table 'data', 'features'
    add_column :features, :value, :float
    add_column :features, :data_type, :integer
    add_column :features, :gene_id, :integer
  end

  def self.down
    remove_column :features, :value
    remove_column :features, :data_type
    remove_column :features, :gene_id
    rename_table 'features', 'data'
  end
end
