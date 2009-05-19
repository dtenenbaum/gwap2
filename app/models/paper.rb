class Paper < ActiveRecord::Base
  has_many :experiments, :through => :citations
  has_many :citations
end
