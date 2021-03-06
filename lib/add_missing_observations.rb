class AddMissingObservations
                                

  # see also AddMissingObservations2

  require 'pp'             
  
  ac = Condition.find :all
  conds = []
  ac.each do |i|
    conds << i if (i.observations.nil? or i.observations.empty?)
  end
  
  
  cond_ids = conds.map{|i|i.id}                         
  old_cond_ids = []
  tmp = {}
                
  
#  puts cond_ids.size
#  exit if true
  
  cond_ids.each do |i|
    c = Condition.find i
    e = c.experiment
    old_conds = Legacy.find_by_sql("select condition_id from condition_groupings where condition_group_id = #{e.gwap1_id}")
    for oc in old_conds
      tmp[oc.condition_id] = 1
    end
  end

  old_cond_ids = tmp.keys
#  puts old_cond_ids.size
#  exit if true
  
#  puts conds.size
#  pp conds.map{|i|i.name}
#  exit if true
  
  # warning: truncating!
#  ControlledVocabItem.connection.execute("truncate table controlled_vocab_items")
#  Observation.connection.execute("truncate table observations")  
#  Unit.connection.execute("truncate table units")
  
  exps = Experiment.find :all
  obs = Legacy.find_by_sql(["select * from properties where property_type = 2 and condition_id != 0 and condition_id in (?)",old_cond_ids])
  obs.each{|i|i.units = "molar" if i.units == "M"}      
#  puts "obs size = #{obs.size}"    
#  exit if true
  
  oldconds = Legacy.find_by_sql(["select * from conditions where id in (?)",old_cond_ids])
  newconds = Condition.find :all
  
  obs_names = obs.collect{|o| o.name}
  obs_names.uniq!   
  
  obs_units = obs.collect{|o| o.units}
  obs_units.uniq!
  
  # can't really intelligently divide units into categories here 
  #units_parent = Unit.new(:name => "Units of Measurement")
  units_parent = Unit.find_by_name("Units of Measurement")
  #units_parent.save
  
  #vocab_parent = ControlledVocabItem.new(:name => 'Observation Names')
  vocab_parent = ControlledVocabItem.find_by_name("Observation Names")
  #vocab_parent.save

  # make sure these names don't exist already
  existing_vocab_items = ControlledVocabItem.find :all       
  existing_units = Unit.find :all

  
  ob_name_hash = {}     
  ob_units_hash  = {}

  
  
  Observation.transaction do
    begin            
      for ob_name in obs_names
        next if ob_name == "knockout"
        puts ob_name
        item = ControlledVocabItem.new(:name => ob_name, :approved => false, :parent_id => vocab_parent.id)
        next if existing_vocab_items.detect{|i|i.name == ob_name} 
        pp item    
        item.save
      end                          

      all_obs = ControlledVocabItem.find :all    
      all_obs.each{|i|ob_name_hash[i.name] = i.id}
      
      for ob_unit in obs_units   
        next if ob_unit.nil?
        #puts "UNIT:"
        #pp ob_unit
        unit = Unit.new(:name => ob_unit, :parent_id => units_parent.id ) # not setting 'approved'
        next if existing_units.detect{|i|i.name = ob_unit}
        pp unit
        unit.save
      end                                                                     
      
      all_units = Unit.find :all
      all_units.each{|i|ob_units_hash[i.name] = i.id}

 #     pp ob_name_hash
#      pp ob_units_hash
#      fail "on purpose"
      

      float_pat =  /^-?[0-9]+\.?[0-9]+$/
      int_pat =  /^-?[0-9]+$/
      sci_pat = /\*10\^/
      sci_pat2 = /e\+/

      for ob in obs
#        next if ob.name == "oxygen"
        next if ob.value.downcase =~ /vng|sirr|idr|ura3/
        ob.units = nil if ob.name == 'Optical density (600nm)'
        gwap1_cond_id = ob.condition_id
        gwap1_cond = oldconds.detect{|c|c.id == gwap1_cond_id.to_i}     
        new_ob = Observation.new()
        new_ob[:condition_id] = newconds.detect{|c|c.name == gwap1_cond.name}.id
        puts "condition id:  #{new_ob[:condition_id]}" 
        new_ob[:name_id] = ob_name_hash[ob.name]   
        new_ob.string_value = ob.value
        new_ob.int_value = ob.value.to_i if ob.value =~ int_pat
        new_ob.float_value = ob.value.to_f if ob.value =~ float_pat or ob.value =~ int_pat
        if (ob.value =~ sci_pat)
          #todo - find out why some #s end up as 0
          num,exp = ob.value.split("*10^")
          new_ob.float_value = num.to_f * (10 ** exp.to_i)

        end           
        if (ob.value =~ sci_pat2)
          new_ob.float_value = ob.value.to_f
        end
        new_ob.units_id = ob_units_hash[ob.units]
        #is_measurement needs to be determined by a human
        new_ob.is_time_measurement = true if ob.name == 'time' #todo could now set time series flag in parent experiment
        pp new_ob
        new_ob.save
      end
      
    rescue Exception => ex
      puts ex.message
      puts ex.backtrace
    end
  end
  
  
  
  
end