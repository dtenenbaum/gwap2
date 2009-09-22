class FixTimeObs
  begin
    Condition.transaction do
      cvo = ControlledVocabItem.find_by_name 'time'
      obs = Observation.find_all_by_name_id cvo.id
      unit = Unit.find_by_name 'minutes'
      for ob in obs
        ob.units_id = unit.id
        ob.is_time_measurement = true
        ob.save
      end
    end
  rescue Exception => ex
    puts ex.message
    puts ex.backtrace
  end
  
end