class AddRepliconIdToFeatures < ActiveRecord::Migration
  def self.up
    add_column :features, :replicon_id, :integer
  end

  def self.down
    remove_column :features, :replicon_id
  end
end
