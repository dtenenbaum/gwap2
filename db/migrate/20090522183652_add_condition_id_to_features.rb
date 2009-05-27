class AddConditionIdToFeatures < ActiveRecord::Migration
  def self.up
    add_column :features, :condition_id, :integer
  end

  def self.down
    remove_column :features, :condition_id
  end
end
