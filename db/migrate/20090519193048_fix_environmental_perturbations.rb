class FixEnvironmentalPerturbations < ActiveRecord::Migration
  def self.up
    drop_table :environmental_perturbations
    create_table :environmental_perturbations do |t|
      t.column :experiment_id, :integer
      t.column :perturbation, :string
    end
  end

  def self.down
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
end
