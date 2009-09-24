class FixOxygen
  require 'pp'
  begin
    Condition.transaction do
      cond_ids = Observation.find_by_sql(["select distinct condition_id from observations where name_id = (select id from controlled_vocab_items where name = 'oxygen')"]).map{|i|i.condition_id}               
      puts "cond_ids: #{cond_ids.size}"
      exp_ids = Observation.find_by_sql(["select distinct experiment_id from conditions where id in (?)",cond_ids]).map{|i|i.experiment_id}
      puts "exp_ids: #{exp_ids.size}"
      #exps = Observation.find_by_sql(["select * from experiments where id in (?)",exp_ids])
      #for exp in exps
      #  puts "id = #{exp.id}, name = #{exp.name}"
      #end
      oxygen = EnvironmentalPerturbation.find_by_perturbation 'oxygen'
      for exp_id in exp_ids
        e = EnvironmentalPerturbationAssociation.new(:environmental_perturbation_id => oxygen.id, :experiment_id => exp_id)
        e.save
      end
    end
  rescue Exception => ex
    puts ex.message
    puts ex.backtrace
  end
end