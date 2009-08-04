class AddIsDuplicateOfToCondition < ActiveRecord::Migration
  def self.up    
    add_column :conditions, :is_duplicate_of, :integer
  end

  def self.down
    remove_column :conditions, :is_duplicate_of
  end
end
require "20090317184423_rename_name_column"
