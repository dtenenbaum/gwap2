class CreateNeighborTypes < ActiveRecord::Migration
  def self.up
    create_table :neighbor_types do |t|
      t.column :name, :string
      t.column :description, :string
    end
  end

  def self.down
    drop_table :neighbor_types
  end
end
