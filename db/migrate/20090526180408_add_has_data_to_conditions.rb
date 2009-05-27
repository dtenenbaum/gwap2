class AddHasDataToConditions < ActiveRecord::Migration
  def self.up
    add_column :conditions, :has_data, :boolean, {:default => true}
#    Condition.connection.execute("update conditions set has_data = true")
  end

  def self.down
    remove_column :conditions, :has_data
  end
end
