class ChangeAbstractDataType < ActiveRecord::Migration
  def self.up 
      change_column :papers, :abstract, :text
  end

  def self.down
    change_column :papers, :abstract, :string
  end
end
