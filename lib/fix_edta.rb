class FixEdta
  begin
    Condition.transaction do
      cvo = ControlledVocabItem.find_by_name 'EDTA'
      obs = Observation.find_all_by_name_id cvo.id
      unit = Unit.find_by_name 'millimolar'
      for ob in obs
        ob.units_id = unit.id
        ob.string_value = "1"
        ob.int_value = 1
        ob.float_value = 1.0
        ob.save
      end
    end
  rescue Exception => ex
    puts ex.message
    puts ex.backtrace
  end
  
end