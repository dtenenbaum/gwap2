class Interaction < Tableless
  column :protein1, :string
  column :protein2, :string
  column :interaction_type_id, :integer
  column :combined_score, :integer
  column :species_id, :integer
  column :egrin_cluster_id, :integer
  attr_accessor_with_default :sources, {}
end