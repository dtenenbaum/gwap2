class AddGrowthRecipeToExperiments < ActiveRecord::Migration
  def self.up
    add_column :experiments, :growth_media_recipe_id, :integer
  end

  def self.down
    remove_column :experiments, :growth_media_recipe_id
  end
end
