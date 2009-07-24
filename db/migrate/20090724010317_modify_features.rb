class ModifyFeatures < ActiveRecord::Migration
  def self.up 
    add_column :features, :start, :integer
    add_column :features, :end, :integer
  end

  def self.down
    remove_column :features, :start
    remove_column :features, :end
  end
end
