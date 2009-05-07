class RenameNameColumn < ActiveRecord::Migration
  def self.up
    rename_column :observations, :name, :name_id
  end

  def self.down
    rename_column :observations, :name_id, :name
  end
end
