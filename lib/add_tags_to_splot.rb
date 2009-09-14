class AddTagsToSplot
  
  begin
    Condition.transaction do
      ids = 404..417
      ids.each do |i|
        ExperimentTag.new(:experiment_id => i, :tag => 'metals', :auto => false, 
          :is_alias => false, :alias_for => 'metals', :tag_category_id => 2).save
      end
    end
  rescue Exception => ex
    puts ex.message
    puts ex.backtrace
  end
  
  
end