class TagCategory < ActiveRecord::Base
  has_many :experiment_tags
end
