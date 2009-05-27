class RemoveExperimentIdFromKnockouts < ActiveRecord::Migration
  def self.up
    remove_column :knockouts, :experiment_id
  end

  def self.down
    add_column :knockouts, :experiment_id, :integer
  end
end
