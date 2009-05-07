class CreateNavTreeItems < ActiveRecord::Migration
  def self.up
    create_table :nav_tree_items do |t|
        t.integer "parent_id"
        t.string  "name"
        t.integer "leaf_id"
        t.integer "level"
        t.integer "experiment_id"
      end
  end

  def self.down
    drop_table :nav_tree_items
  end
end
