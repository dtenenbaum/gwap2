class CreateEnvironmentalPerturbations < ActiveRecord::Migration
  def self.up
    create_table :environmental_perturbations do |t|
        t.column :experiment_id, :integer
        t.column :name, :integer #reference to vocab item 
        t.column :string_value, :string
        t.column :int_value, :integer
        t.column :float_value, :float
        t.column :units_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :environmental_perturbations
  end
end
