class CreateGeneToPositionMaps < ActiveRecord::Migration
  def self.up
    create_table :gene_to_position_maps do |t|
        t.column :platform_id, :integer
        t.column :gene, :string
        t.column :start, :integer
        t.column :end, :integer
        t.column :strand, :string
        t.column :probe_start, :integer
        t.column :probe_end, :integer
        t.column :molecule, :string
        #gene name (e.g. yvr0)??
      t.timestamps
    end
  end

  def self.down
    drop_table :gene_to_position_maps
  end
end
