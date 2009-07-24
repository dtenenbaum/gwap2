class AddStrandToFeatures < ActiveRecord::Migration
  def self.up
    add_column :features, :strand, :boolean
  end

  def self.down
    add_column :features, :strand
  end
end
