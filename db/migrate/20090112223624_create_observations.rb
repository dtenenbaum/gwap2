class CreateObservations < ActiveRecord::Migration
  def self.up
    create_table :observations do |t|
        t.column :condition_id, :integer
        t.column :name, :integer #reference to vocab item name
        t.column :string_value, :string
        t.column :int_value, :integer
        t.column :float_value, :float
        t.column :units_id, :integer # need to match name of lookup table?
        t.column :is_measurement, :boolean #or is_perturbation?
        t.column :is_time_measurement, :boolean
      t.timestamps
    end
  end

  def self.down
    drop_table :observations
  end
end
