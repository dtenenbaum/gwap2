class FixFeatures < ActiveRecord::Migration
  def self.up 
    remove_column :features, :start
    remove_column :features, :end
    remove_column :features, :strand
    remove_column :features, :replicon_id
    remove_column :features, :created_at
    remove_column :features, :updated_at
    add_column :features, :location_id, :integer
  end

  def self.down
    add_column :features, :start, :integer
    add_column :features, :end, :integer
    add_column :features, :strand, :string
    add_column :features, :replicon_id, :integer
    add_column :features, :created_at, :datetime
    add_column :features, :updated_at, :datetime
    remove_column :features, :location_id, :integer
  end
end
