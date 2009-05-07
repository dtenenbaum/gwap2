class CreateSearchTerms < ActiveRecord::Migration
  def self.up
    create_table :search_terms do |t|
        t.column :word, :string
        t.column :experiment_id, :integer
        # also want condition_id here? sure:
        t.column :condition_id, :integer
      t.timestamps
    end     
    execute("ALTER TABLE search_terms ENGINE=MyISAM") # do we really want this? what about transactions?
  end

  def self.down
    drop_table :search_terms
  end
end
