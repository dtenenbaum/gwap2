class AddIndexToGenes < ActiveRecord::Migration
  def self.up
    add_index(:genes, :name)
  end

  def self.down
    remove_index(:genes, :name)
  end
end
