class ChangeExperimentTags
  require 'pp'
  map = {}
  exps = Experiment.find :all
  exps.each{|i|map[i.id]=i}
  
  tags = ExperimentTag.find :all
  
  begin
    Condition.transaction do
      for tag in tags
        exp = map[tag.experiment_id]
        conds = exp.conditions
        for cond in conds
          new_tag = tag.clone
          new_tag.experiment_id = nil
          new_tag.condition_id = cond.id
          new_tag.save
          #pp new_tag
        end         
        ExperimentTag.delete(tag.id)
      end
    end
  rescue Exception => ex
    puts ex.message
    puts ex.backtrace
  end
  
end