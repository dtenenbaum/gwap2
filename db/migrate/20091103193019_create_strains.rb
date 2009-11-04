class CreateStrains < ActiveRecord::Migration
  def self.up
    create_table :strains do |t|
      t.column :description, :string
    end
  end

  def self.down
    drop_table :strains
  end
end
