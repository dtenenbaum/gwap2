class Observation < ActiveRecord::Base
  belongs_to :condition 
  #has_one :controlled_vocab_item, :primary_key => :name_id
  #belongs_to :name, :class_name => "ControlledVocabItem", :foreign_key => :name_id
  belongs_to :controlled_vocab_item, :foreign_key => :name_id
  belongs_to :unit, :foreign_key => :units_id
  delegate :name, :to => :controlled_vocab_item
  delegate :unit_name, :to => :unit, :default => nil
end
