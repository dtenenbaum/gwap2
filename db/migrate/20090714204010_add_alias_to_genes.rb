class AddAliasToGenes < ActiveRecord::Migration
  def self.up
    add_column :genes, :alias, :string
  end

  def self.down
    remove_column :genes, :alias
  end
end
