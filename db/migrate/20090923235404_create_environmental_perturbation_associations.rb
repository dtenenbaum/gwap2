class CreateEnvironmentalPerturbationAssociations < ActiveRecord::Migration
  def self.up
    create_table :environmental_perturbation_associations do |t|
      t.column :environmental_perturbation_id, :integer
      t.column :experiment_id, :integer
    end
  end

  def self.down
    drop_table :environmental_perturbation_associations
  end
end
