class AddConditionIdToNeighbors < ActiveRecord::Migration
  def self.up
    add_column :condition_neighbors, :condition_id, :integer
  end

  def self.down
    remove_column :condition_neighbors, :condition_id
  end
end
