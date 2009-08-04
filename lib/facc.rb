class Facc
  require 'pp'
  exp_ids = Condition.find_by_sql("select distinct experiment_id from conditions where name like '%tfb%' or '%tbp%'").map{|i|i.experiment_id}
  
  marc = Paper.find_by_short_name("Facciotti, 2007")
  
  exps = Experiment.find_by_sql(["select * from experiments where id in (?)", exp_ids])
  
  controlled_vocab_items = ControlledVocabItem.find :all
  oe = controlled_vocab_items.detect{|i|i.name == 'overexpressed gene'}
  tag = controlled_vocab_items.detect{|i|i.name == 'tag'}

  begin
    Condition.transaction do
        for exp in exps
          puts exp.name
          for ko in exp.knockouts
            puts "\t#{ko.gene}"
          end
          obs = exp.conditions.first.observations
          oe_value = obs.detect{|i|i.name_id == oe}.string_value
          tag_value = obs.detect{|i|name_id == tag}.string_value
          
          # figure out which are KOs and which are OEs (and which are both???)
      #    exp.papers << marc
        end
    end
  rescue Exception => ex
    puts ex.message
    puts ex.backtrace
  end


  
  
end