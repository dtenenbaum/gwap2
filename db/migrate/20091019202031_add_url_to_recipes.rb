class AddUrlToRecipes < ActiveRecord::Migration
  def self.up
    add_column :growth_media_recipes, :url, :string
  end

  def self.down
    remove_column :growth_media_recipes, :url
  end
end
