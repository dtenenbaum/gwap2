class AddControlFor < ActiveRecord::Migration
  def self.up
    add_column :knockouts, :control_for, :string
    add_column :overexpressions, :control_for, :string
  end

  def self.down
    remove_column :knockouts, :control_for
    remove_column :overexpressions, :control_for
  end
end
