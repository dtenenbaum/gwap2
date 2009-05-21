class AddAutoToTag < ActiveRecord::Migration
  def self.up 
    add_column :experiment_tags, :auto, :boolean
  end

  def self.down
    remove_column :experiment_tags, :auto
  end
end
