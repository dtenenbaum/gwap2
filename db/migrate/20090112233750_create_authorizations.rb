class CreateAuthorizations < ActiveRecord::Migration
  def self.up
    create_table :authorizations do |t|
        t.column :user_id, :integer
        t.column :group_id, :integer
        t.column :experiment_id, :integer
        t.column :permission, :string #create/read/update/delete -- should this be a lookup? & should it be called 'action'?
      t.timestamps
    end
  end

  def self.down
    drop_table :authorizations
  end
end
