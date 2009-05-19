class AddRankings < ActiveRecord::Migration
  def self.up
    add_column :knockouts, :ranking, :integer
    add_column :overexpressions, :ranking, :integer
  end

  def self.down
    remove_column :knockouts, :ranking
    remove_column :overexpressions, :ranking
  end
end
