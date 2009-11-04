class CreateConditionNeighbors < ActiveRecord::Migration
  def self.up
    create_table :condition_neighbors do |t|
      t.column :next_neighbor, :integer
      t.column :previous_neighbor, :integer
      t.column :neighbor_type_id, :integer
    end
  end

  def self.down
    drop_table :condition_neighbors
  end
end
