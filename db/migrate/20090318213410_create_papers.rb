class CreatePapers < ActiveRecord::Migration
  def self.up
    create_table :papers do |t|
      t.column :title, :string
      t.column :url, :string
      t.column :authors, :string
      t.column :abstract, :string
    end
  end

  def self.down
    drop_table :papers
  end
end
