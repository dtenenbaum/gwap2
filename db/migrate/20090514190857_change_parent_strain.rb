class ChangeParentStrain < ActiveRecord::Migration
  def self.up  
    remove_column :knockouts, :parent_strain
    add_column :knockouts, :parent_id, :integer
  end

  def self.down
  end
end
