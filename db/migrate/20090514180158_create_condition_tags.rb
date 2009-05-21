class CreateConditionTags < ActiveRecord::Migration
  def self.up
    create_table :condition_tags do |t|
      t.column :condition_id, :integer
      t.column :tag, :string
    end
  end

  def self.down
    drop_table :condition_tags
  end
end
