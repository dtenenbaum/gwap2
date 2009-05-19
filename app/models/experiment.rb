class Experiment < ActiveRecord::Base
  has_many :conditions, :order => 'sequence'
  has_many :papers, :through => :citations      
  has_many :citations     
  has_many :knockouts, :order => 'ranking'        
  has_many :experiment_tags
  has_many :environmental_perturbations
#  has_one :curation_status, :foreign_key => 'curation_status_id'  
  belongs_to :curation_status
  belongs_to :growth_media_recipe
  belongs_to :owner, :class_name => "User", :foreign_key => :importer_id    
  belongs_to :platform
  belongs_to :reference_sample
  belongs_to :species
end
