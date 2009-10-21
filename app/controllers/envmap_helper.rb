class EnvmapHelper
  
  def self.get_conditions_from_ids(cond_ids)       
    @envmap_file = ""
    @conditions = Condition.find_by_sql(["select * from conditions where id in (?)",cond_ids])
  end


  def self.assemble_data()
    @all_prop_names = {}
    for condition in @conditions
      props = Observation.find :all, :conditions => ['condition_id = ?',condition.id]
      data = {}
      for prop in props
        prop.name = 'temperature' if prop.name == 'Temperature'
        @all_prop_names[prop.name] = ' '
        data[prop.name] = prop.string_value
      end                           
      condition['props'] = data
    end
  end             

  def self.print_header()
    @columns = @all_prop_names.keys.sort{|a,b| a.downcase <=> b.downcase}
    @envmap_file << "\t"
    line = ""
    for col in @columns
      line += col
      line += "\t"
    end           
    line.strip!
    line << "\n"
    @envmap_file << line
  end           

  def self.print_data()
    for condition in @conditions
      @envmap_file << condition.name
      @envmap_file << "\t"
      line = ""
      for col in @columns
        value = condition['props'][col]
        value = "0" if value.nil? or value.strip.empty?
        line << value
        line << "\t"
      end

      line.strip!
      line << "\n"
      @envmap_file << line
    end
  end

        
  def self.get_envmap(condition_ids)
    get_conditions_from_ids(condition_ids)
    assemble_data()
    print_header() 
    print_data()     
    return @envmap_file
  end

#  main()
end