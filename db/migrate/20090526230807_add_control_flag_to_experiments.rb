class AddControlFlagToExperiments < ActiveRecord::Migration
  def self.up
    add_column :experiments, :is_control, :boolean, {:default => false}
  end

  def self.down
    remove_column :experiments, :is_control
  end
end
