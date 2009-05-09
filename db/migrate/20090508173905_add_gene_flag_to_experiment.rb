class AddGeneFlagToExperiment < ActiveRecord::Migration
  def self.up
    add_column :experiments, :uses_probe_numbers, :boolean
  end

  def self.down
    remove_column :experiments, :uses_probe_numbers
  end
end
