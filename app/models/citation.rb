class Citation < ActiveRecord::Base
  belongs_to :experiment
  belongs_to :paper
end
