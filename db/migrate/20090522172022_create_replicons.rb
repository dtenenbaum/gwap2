class CreateReplicons < ActiveRecord::Migration
  def self.up
    create_table :replicons do |t|
      t.column :species_id, :integer
      t.column :name, :string
    end
  end

  def self.down
    drop_table :replicons
  end
end
