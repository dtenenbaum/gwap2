class Experiment < ActiveRecord::Base
  has_many :conditions, :order => 'sequence'
  has_many :papers, :through => :citations      
  has_many :citations     
  has_many :knockouts, :through => :knockout_associations#, :order => 'ranking'
  has_many :knockout_associations
  has_many :experiment_tags, :order => 'tag'
  has_many :environmental_perturbations, :through => :environmental_perturbation_associations
  has_many :environmental_perturbation_associations
#  has_one :curation_status, :foreign_key => 'curation_status_id'  
  belongs_to :curation_status
  belongs_to :growth_media_recipe
  belongs_to :owner, :class_name => "User", :foreign_key => :owner_id    
  belongs_to :importer, :class_name => "User", :foreign_key => :importer_id    
  belongs_to :platform
  belongs_to :reference_sample
  belongs_to :species         
  
  attr_accessor :all_conditions_included, :num_conditions_included
end
