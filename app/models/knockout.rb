class Knockout < ActiveRecord::Base  
  acts_as_tree  
  has_many :experiments, :through => :knockout_associations
  has_many :knockout_associations
end
