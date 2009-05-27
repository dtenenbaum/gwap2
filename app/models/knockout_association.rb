class KnockoutAssociation < ActiveRecord::Base
  belongs_to :experiment
  belongs_to :knockout
end
