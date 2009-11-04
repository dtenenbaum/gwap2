class FixFirstLast
  require 'pp'
  nabes = ConditionNeighbor.find :all
  
  conditions = Condition.find :all
  
  cond_to_exp = {}
                                  
  for cond in conditions
    cond_to_exp[cond.id] = Experiment.find cond.experiment_id
  end
 
  
  for nabe in nabes
    exp = cond_to_exp[nabe.condition_id]
    nabe.first_in_series = exp.conditions.first.id
    nabe.last_in_series = exp.conditions.last.id
    #pp nabe                                     
    nabe.save
  end
end