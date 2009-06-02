class AddShortNameToPapers < ActiveRecord::Migration
  def self.up
    add_column :papers, :short_name, :string
  end

  def self.down
    remove_column :papers, :short_name
  end
end
