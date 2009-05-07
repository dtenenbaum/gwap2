class CreateGrowthMediaRecipes < ActiveRecord::Migration
  def self.up
    create_table :growth_media_recipes do |t|
        t.column :name, :string
        t.column :description, :text
      t.timestamps
    end
  end

  def self.down
    drop_table :growth_media_recipes
  end
end
