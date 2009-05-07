class UsersGroups < ActiveRecord::Migration
  def self.up
    create_table(:users_groups, :id => false) do |t|
      t.column :user_id, :integer
      t.column :group_id, :integer
    end
  end

  def self.down
  end
end
