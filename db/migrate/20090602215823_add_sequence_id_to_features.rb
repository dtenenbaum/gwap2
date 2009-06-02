class AddSequenceIdToFeatures < ActiveRecord::Migration
  def self.up
    add_column :features, :sequence_id, :integer
  end

  def self.down
    remove_column :features, :sequence_id
  end
end
