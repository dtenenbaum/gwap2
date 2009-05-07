class CreateConditions < ActiveRecord::Migration
  def self.up
    create_table :conditions do |t|
        t.column :experiment_id, :integer
        t.column :name, :string
        t.column :sequence, :integer
        
      t.timestamps
    end
  end

  def self.down
    drop_table :conditions
  end
end
