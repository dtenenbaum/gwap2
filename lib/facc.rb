class Facc
  require 'pp'
  exp_ids = Condition.find_by_sql("select distinct experiment_id from conditions where name like '%tfb%' or '%tbp%'").map{|i|i.experiment_id}
  
  marc = Paper.find_by_short_name("Facciotti, 2007")
  
  exps = Experiment.find_by_sql(["select * from experiments where id in (?)", exp_ids])
  
  for exp in exps
    puts exp.name
    exp.papers << marc
  end
  
end