class RemoveOrphans
  require 'pp'
  all_conds = Condition.find :all
  conds_to_remove = []
  
  all_exps = Experiment.find :all
  exp_id_hash = {}
  all_exps.each{|i|exp_id_hash[i.id] = 1}
              
  cond_id_hash = {}
  all_conds.each{|i|cond_id_hash[i.id] = 1}
  
  all_obs = Observation.find :all
  
  
  
  begin
    Condition.transaction do
      for cond in all_conds
        unless exp_id_hash.has_key?(cond.experiment_id)
          puts "whoops, no parent experiment for: "
          pp cond
          puts
          # delete it
        end
      end
      
      for ob in all_obs
        unless cond_id_hash.has_key?(ob.condition_id)
          puts "whoops, no parent condition for:"
          pp ob
          puts
          # delete
        end
      end
      
    end
  rescue Exception => ex
    puts ex.message
    puts ex.backtrace
  end
  
  
end