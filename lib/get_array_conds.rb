class GetArrayConds
  for cond in Condition.find :all
    size = Feature.find_by_sql(["select count(*) as result from features where condition_id = ?", cond.id]).first.result.to_i
    
    puts "#{cond.name} #{size}" if size != 4800   
    #puts size
  end
end