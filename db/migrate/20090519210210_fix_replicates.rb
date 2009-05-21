class FixReplicates < ActiveRecord::Migration
  def self.up   
    rename_column :experiments, :replicate, :technical_replicate
  end

  def self.down
    rename_column :experiments, :technical_replicate, :replicate
  end
end
