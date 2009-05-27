class ReimportMetalConds

  f = File.open("#{RAILS_ROOT}/data/missing_metal_conds.txt")
  condnames = []
  while (line = f.gets)
    line.chomp!
    next if line.empty?
    condnames << line
  end


  
  cond_groupings = Legacy.find_by_sql("select * from condition_groupings")
  
##  Condition.connection.execute("truncate table conditions")
  
  condmap = {}
  for item in cond_groupings
    condmap[item.condition_id.to_i] = item.condition_group_id.to_i
  end            
  
     
  exps = Experiment.find :all

  old_conds = Legacy.find_by_sql(["select * from conditions where name in (?)",condnames])
  
  
  Condition.transaction do
    begin
      for old_cond in old_conds
        new_cond = Condition.new()    
        parent_exp = exps.detect{|d| d.gwap1_id == condmap[old_cond.id]}
        new_cond.experiment_id = parent_exp.id

        new_cond.name = old_cond.name
        new_cond.sequence = old_cond.orig_sequence
        new_cond.save
      end
    rescue Exception => ex
      puts ex.message
      puts ex.backtrace
    end
  end
  
  
end