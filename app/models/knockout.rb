class Knockout < ActiveRecord::Base    
  attr_accessor :gene_alias
  acts_as_tree  
  has_many :experiments, :through => :knockout_associations
  has_many :knockout_associations     
  
  def gene_and_alias()
    return gene if gene_alias.nil?
    "#{gene} (#{gene_alias})"
  end
  
end
