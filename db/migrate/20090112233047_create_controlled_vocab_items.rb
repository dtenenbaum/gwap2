class CreateControlledVocabItems < ActiveRecord::Migration
  def self.up
    create_table :controlled_vocab_items do |t|
        t.column :name, :string
        t.column :approved, :boolean # should it be integer instead to match curation levels?
        t.column :parent_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :controlled_vocab_items
  end
end
