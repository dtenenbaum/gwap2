class PopulateNeighbors
  require 'pp'
  experiments = Experiment.find :all

  def self.set_up_neighbors(conditions)
    conditions.each_with_index do |condition, i|
      p = (i == 0) ? nil : conditions[i-1].id
      n = (i == (conditions.size-1)) ? nil : conditions[i+1].id
      f = conditions.first.id
      l = conditions.last.id
      neighbor = ConditionNeighbor.new(:neighbor_type_id => 1, :condition_id => condition.id, :previous_neighbor => p, :next_neighbor => n,
        :first_in_series => f, :last_in_series => l)
      neighbor.save
    end
    puts "saved"
  end

  
  begin
    Condition.transaction do
      for experiment in experiments
        puts "#{experiment.id}\t#{experiment.name}" 
        for condition in experiment.conditions
          puts "\t#{condition.name}"
        end 
        print "define as time series? (Y/n) "
        response = gets
        
        next if response.chomp.length != 0 and response.chomp.downcase != 'y'
        set_up_neighbors(experiment.conditions)
      end
    end
  rescue Exception => ex
    puts ex.message
    puts ex.backtrace
  end
  
  
  
end