class CreateCurationStatuses < ActiveRecord::Migration
  def self.up
    create_table :curation_statuses do |t|
        t.column :name, :string
        t.column :description, :text
      t.timestamps
    end
  end

  def self.down
    drop_table :curation_statuses
  end
end
