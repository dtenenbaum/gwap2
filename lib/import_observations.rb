class ImportObservations

  require 'pp'             
  
  
  f = File.open("/Users/dtenenbaum/dl/metals_envmap.txt")
  cond_names = []
  first = true
  while line = f.gets
    line.chomp!
    next if line.empty?
    if (first)
      first = false
      next
    end
    segs = line.split("\t")
    cond_names << segs.first
  end 
  conds = Legacy.find_by_sql(["select * from conditions where name in (?)",cond_names])
  cond_ids = conds.map{|i|i.id}
  
  
  # warning: truncating!
  ControlledVocabItem.connection.execute("truncate table controlled_vocab_items")
  Observation.connection.execute("truncate table observations")  
  Unit.connection.execute("truncate table units")
  
  exps = Experiment.find :all
  obs = Legacy.find_by_sql(["select * from properties where property_type = 2 and condition_id != 0 and condition_id in (?)",cond_ids])
  
  oldconds = Legacy.find_by_sql(["select * from conditions where id in (?)",cond_ids])
  newconds = Condition.find :all
  
  obs_names = obs.collect{|o| o.name}
  obs_names.uniq!   
  
  obs_units = obs.collect{|o| o.units}
  obs_units.uniq!
  
  # can't really intelligently divide units into categories here 
  units_parent = Unit.new(:name => "Units of Measurement")
  units_parent.save
  
  vocab_parent = ControlledVocabItem.new(:name => 'Observation Names')
  vocab_parent.save
  
  ob_name_hash = {}
  ob_units_hash  = {}
  
  for ob_name in obs_names
    item = ControlledVocabItem.new(:name => ob_name, :approved => false, :parent_id => vocab_parent.id)
    item.save
    ob_name_hash[item.name] = item.id
  end                          
  
  for ob_unit in obs_units
    unit = Unit.new(:name => ob_unit, :parent_id => units_parent.id ) # not setting 'approved'
    unit.save
    ob_units_hash[unit.name] = unit.id
  end                                                                     
                   
  

  float_pat =  /^-?[0-9]+\.?[0-9]+$/
  int_pat =  /^-?[0-9]+$/
  sci_pat = /\*10\^/
  
  for ob in obs
    gwap1_cond_id = ob.condition_id
    gwap1_cond = oldconds.detect{|c|c.id == gwap1_cond_id.to_i}     
    new_ob = Observation.new()
    new_ob[:condition_id] = newconds.detect{|c|c.name == gwap1_cond.name}.id
    new_ob[:name_id] = ob_name_hash[ob.name]
    new_ob.string_value = ob.value
    new_ob.int_value = ob.value.to_i if ob.value =~ int_pat
    new_ob.float_value = ob.value.to_f if ob.value =~ float_pat or ob.value =~ int_pat
    if (ob.value =~ sci_pat)
      #todo - find out why some #s end up as 0
      num,exp = ob.value.split("*10^")
      new_ob.float_value = num.to_f * (10 ** exp.to_i)
      
    end
    new_ob.units_id = ob_units_hash[ob.units]
    #is_measurement needs to be determined by a human
    new_ob.is_time_measurement = true if ob.name == 'time' #todo could now set time series flag in parent experiment
    new_ob.save
  end
  
  
end