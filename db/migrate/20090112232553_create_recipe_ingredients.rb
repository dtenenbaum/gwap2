class CreateRecipeIngredients < ActiveRecord::Migration
  def self.up
    create_table :recipe_ingredients do |t|
        t.column :growth_media_recipe_id, :integer
        t.column :name, :string
        t.column :value, :string # need int and float versions?
        t.column :value2, :string #need to clarify purpose of this column
        t.column :ingredient_category_id, :integer
        t.column :amount, :string
        t.column :units_id, :integer
        t.column :units2_id, :integer # clarify
      t.timestamps
    end
  end

  def self.down
    drop_table :recipe_ingredients
  end
end
