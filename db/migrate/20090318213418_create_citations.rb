class CreateCitations < ActiveRecord::Migration
  def self.up
    create_table :citations do |t|
      t.column :paper_id, :integer
      t.column :experiment_id, :integer
    end
  end

  def self.down
    drop_table :citations
  end
end
