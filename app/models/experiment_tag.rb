class ExperimentTag < ActiveRecord::Base       
  # this model/table should really be renamed to ConditionTag
  belongs_to :tag_category
  belongs_to :user, :foreign_key => "owner_id"
end
