class CreateGenes < ActiveRecord::Migration
  def self.up
    create_table :genes do |t|
      t.column :name, :string
    end
  end

  def self.down
    drop_table :genes
  end
end
