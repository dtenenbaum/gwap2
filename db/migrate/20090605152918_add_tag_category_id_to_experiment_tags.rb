class AddTagCategoryIdToExperimentTags < ActiveRecord::Migration
  def self.up
    add_column :experiment_tags, :tag_category_id, :integer
  end

  def self.down
    remove_column :experiment_tags, :tag_category_id
  end
end
