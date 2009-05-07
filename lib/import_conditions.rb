class ImportConditions
  
  cond_groupings = Legacy.find_by_sql("select * from condition_groupings")
  
  Condition.connection.execute("truncate table conditions")
  
  condmap = {}
  for item in cond_groupings
    condmap[item.condition_id.to_i] = item.condition_group_id.to_i
  end            
  
     
  exps = Experiment.find :all
  
  old_conds = Legacy.find_by_sql("select * from conditions")
  
  for old_cond in old_conds
    new_cond = Condition.new()    
    parent_exp = exps.detect{|d| d.gwap1_id == condmap[old_cond.id]}
    new_cond.experiment_id = parent_exp.id
    
    new_cond.name = old_cond.name
    new_cond.sequence = old_cond.orig_sequence
    
    
    # are created_at and updated_at valuable in this context?
    
    new_cond.save
  end
end