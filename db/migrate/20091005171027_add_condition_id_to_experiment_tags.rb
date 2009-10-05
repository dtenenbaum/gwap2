class AddConditionIdToExperimentTags < ActiveRecord::Migration
  def self.up                                                         
    # should probably rename the table too, but wtf...
    add_column :experiment_tags, :condition_id, :integer
  end

  def self.down
    remove_column :experiment_tags, :condition_id
  end
end
