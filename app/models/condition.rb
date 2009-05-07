class Condition < ActiveRecord::Base
  belongs_to :experiment
  has_many :observations
end
