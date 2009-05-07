class CreateData < ActiveRecord::Migration
  def self.up
    create_table :data do |t|
        t.column :track_id, :integer
        t.column :start, :integer
        t.column :end, :integer
        t.column :strand, :string #or char(1)?
      t.timestamps
    end
  end

  def self.down
    drop_table :data
  end
end
