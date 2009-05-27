class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.column :start, :integer
      t.column :end, :integer
      t.column :strand, :string
      t.column :replicon_id, :integer
    end
  end

  def self.down
    drop_table :locations
  end
end
