class Experiment < ActiveRecord::Base
  has_many :conditions, :order => 'sequence'
  has_many :papers, :through => :citations
end
