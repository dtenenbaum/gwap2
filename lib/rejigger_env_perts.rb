class RejiggerEnvPerts
  require 'pp'
  begin
    Condition.transaction do
      Condition.connection.execute "truncate table environmental_perturbations"
      Condition.connection.execute "truncate table environmental_perturbation_associations"
      f = File.open("#{RAILS_ROOT}/data/old_env_perts.txt")
      map = {}
      reducer = {}
      while(line = f.gets)
        old_id, exp_id, env_pert = line.chomp.split("\t")
        key = [env_pert, exp_id.to_i]
        reducer[key] = 1
      end    
      #pp reducer
      #raise 'bla'
      reducer.each_key do |item|
        map[item.first] = [] unless map.has_key?(item.first)
        map[item.first] << item.last
      end
      #map[env_pert] = [] unless map.has_key?(env_pert)
      #map[env_pert] << exp_id.to_i
      #pp map
      #raise 'cain'
      map.each_pair do |k,v|
        #puts "k = #{k}"
        pert = EnvironmentalPerturbation.new(:perturbation => k)
        pert.save
        for item in v
          ass = EnvironmentalPerturbationAssociation.new(:environmental_perturbation_id => pert.id, :experiment_id => item)
          ass.save
          #pp ass
        end
        #puts
      end
    end
  rescue Exception => ex
    puts ex.message
    puts ex.backtrace
  end
  
end