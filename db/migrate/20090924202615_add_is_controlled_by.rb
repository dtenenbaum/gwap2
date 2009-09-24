class AddIsControlledBy < ActiveRecord::Migration
  def self.up
    add_column :experiments, :is_controlled_by, :integer
  end

  def self.down
    remove_column :experiments, :is_controlled_by
  end
end
