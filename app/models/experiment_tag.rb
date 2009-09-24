class ExperimentTag < ActiveRecord::Base
  belongs_to :tag_category
  belongs_to :user, :foreign_key => "owner_id"
end
