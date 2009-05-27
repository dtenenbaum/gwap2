class CreateKnockoutAssociations < ActiveRecord::Migration
  def self.up
    create_table :knockout_associations do |t|
      t.column :knockout_id, :integer
      t.column :experiment_id, :integer
    end
  end

  def self.down
    drop_table :knockout_associations
  end
end
