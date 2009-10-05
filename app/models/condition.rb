class Condition < ActiveRecord::Base  
  attr_accessor :included
  belongs_to :experiment
  has_many :observations
end
