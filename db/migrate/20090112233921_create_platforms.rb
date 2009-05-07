class CreatePlatforms < ActiveRecord::Migration
  def self.up
    create_table :platforms do |t|
        t.column :name, :string
        t.column :description, :text    
      t.timestamps
    end
  end

  def self.down
    drop_table :platforms
  end
end
