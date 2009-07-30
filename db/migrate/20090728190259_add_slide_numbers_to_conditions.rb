class AddSlideNumbersToConditions < ActiveRecord::Migration
  def self.up
    add_column :conditions, :forward_slide_number, :integer
    add_column :conditions, :reverse_slide_number, :integer
  end

  def self.down
    remove_column :conditions, :forward_slide_number
    remove_column :conditions, :reverse_slide_number
  end
end
