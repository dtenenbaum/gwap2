class CreateKnockouts < ActiveRecord::Migration
  def self.up
    create_table :knockouts do |t|
        t.column :experiment_id, :integer
        t.column :parent_strain, :string # or should it be an index into a lookup? probably.
        t.column :gene, :string #or index into a lookup?
        # is order important? if so we need a sequence column
      t.timestamps
    end
  end

  def self.down
    drop_table :knockouts
  end
end
