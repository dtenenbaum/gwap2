class AddAmountToOverexpression < ActiveRecord::Migration
  def self.up     
    add_column :overexpressions, :amount, :float
  end

  def self.down
    remove_column :overexpressions, :amount
  end
end
