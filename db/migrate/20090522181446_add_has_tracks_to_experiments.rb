class AddHasTracksToExperiments < ActiveRecord::Migration
  def self.up
    add_column :experiments, :has_tracks, :boolean
  end

  def self.down
    remove_column :experiments, :has_tracks
  end
end
