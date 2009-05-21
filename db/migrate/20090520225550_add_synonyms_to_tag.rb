class AddSynonymsToTag < ActiveRecord::Migration
  def self.up
    add_column :experiment_tags, :is_alias, :boolean
    add_column :experiment_tags, :alias_for, :string
  end

  def self.down
    remove_column :experiment_tags, :is_alias
    remove_column :experiment_tags, :alias_for
  end
end
