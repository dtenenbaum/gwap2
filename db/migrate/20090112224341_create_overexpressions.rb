class CreateOverexpressions < ActiveRecord::Migration
  def self.up
    create_table :overexpressions do |t|
        t.column :experiment_id, :integer
        t.column :tag, :string #lookup?
        t.column :gene, :string #lookup?
        t.column :plasmid, :string # lookup?
        #parent_strain?
        #sequence/order?
        t.column :position, :string # N-term|C-term|other
      t.timestamps
    end
  end

  def self.down
    drop_table :overexpressions
  end
end
