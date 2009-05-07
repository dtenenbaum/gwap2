class Paper < ActiveRecord::Base
  has_many :experiments, :through => :citations
end
