class CreateIngredientCategories < ActiveRecord::Migration
  def self.up
    create_table :ingredient_categories do |t|
        t.column :name, :string
        # values: Salts (per L), Vitamins (per L), Amino Acids (per L), carbon source, trace metals, pH
        # is this table necessary?
      t.timestamps
    end
  end

  def self.down
    drop_table :ingredient_categories
  end
end
