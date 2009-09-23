class AddTagOwner < ActiveRecord::Migration
  def self.up
    add_column :experiment_tags, :owner_id, :integer
  end

  def self.down
    remove_column :experiment_tags, :owner_id, :integer
  end
end
