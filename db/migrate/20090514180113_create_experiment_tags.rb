class CreateExperimentTags < ActiveRecord::Migration
  def self.up
    create_table :experiment_tags do |t|
      t.column :experiment_id, :integer
      t.column :tag, :string
    end
  end

  def self.down
    drop_table :experiment_tags
  end
end
