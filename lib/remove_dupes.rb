class RemoveDupes       
  require 'pp'
  all_exps = Experiment.find :all
  all_exps.reverse!
  
  name_hash = {}
  dupes = {}
  
  all_exps.each do |i|
    if(name_hash.has_key?(i.name))
      dupes[i.name] = i.id
    end
    name_hash[i.name] = i.id
  end
  
  pp dupes


  begin
    Experiment.transaction do
      dupes.each_pair do |k,v|
        e = Experiment.find(v)
        conds = e.conditions
        for cond in conds
          for ob in cond.observations
            puts "\t\tabout to delete observation #{ob.id}"
            Observation.delete(ob.id)
          end
          puts "\tabout to delete condition #{cond.id}"
          Condition.delete(cond.id)
        end
        puts "about to delete experiment #{v}"
        Experiment.delete(v)
      end
    end
  rescue Exception => ex
    puts ex.message
    puts ex.backtrace
  end

  
end


__END__

removes dupe conditions:


  require 'pp'
  all_conds = Condition.find :all
  all_conds.reverse!
  name_hash = {}                                        
  dupes = {}
  all_conds.each do |i|
    if (name_hash.has_key?(i.name))
#      puts "DUPLICATE! #{name_hash[i.name]} and #{i.id}"
      dupes[i.name] = i.id
    end
    name_hash[i.name] = i.id
  end
  
 # puts dupes.keys.size
  
  begin
    Condition.transaction do
      dupes.each_pair do |k,v|
        puts "about to delete condition #{v}"
        Condition.delete(v)
      end
    end
  rescue Exception => ex
    puts ex.message
    puts ex.backtrace
  end
