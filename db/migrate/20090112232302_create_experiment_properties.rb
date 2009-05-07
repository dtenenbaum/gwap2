class CreateExperimentProperties < ActiveRecord::Migration
  def self.up
    create_table :experiment_properties do |t|
        t.column :experiment_id, :integer
        t.column :name, :integer #ookup
        t.column :string_value, :string
        t.column :int_value, :integer
        t.column :float_value, :float
        t.column :units_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :experiment_properties
  end
end
