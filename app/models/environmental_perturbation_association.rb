class EnvironmentalPerturbationAssociation < ActiveRecord::Base
  belongs_to :experiment
  belongs_to :environmental_perturbation
end
