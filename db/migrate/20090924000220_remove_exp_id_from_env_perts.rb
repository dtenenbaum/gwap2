class RemoveExpIdFromEnvPerts < ActiveRecord::Migration
  def self.up 
    remove_column :environmental_perturbations, :experiment_id
  end

  def self.down
    add_column :environmental_perturbations, :experiment_id, :integer
  end
end
