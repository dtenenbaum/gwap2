class ColmapHelper

  require 'pp'

  def self.read_conditions()      
      if ARGV.nil? or ARGV.empty?
        puts "supply a filename"
        exit
      end
      f = File.open(ARGV.first)  #("#{RAILS_ROOT}/conditions_phu_wants.txt")  

      @colmap_file = File.open("#{RAILS_ROOT}/colmap.txt", "w")
      @conditions = []         
      while line = f.gets
        c = Condition.find :first, :conditions => "name = '#{line.chomp!}'"
        if (c.nil?)
          puts "missing condition #{line}"
          next
        end
        @conditions << c
      end
  end    

  def self.read_parents
    p = Condition.find_by_sql("select condition_id, condition_group_id from condition_groupings")
    @childToParentMap = {}
    for item in p
      @childToParentMap[item.condition_id.to_i] = item.condition_group_id.to_i
    end
    tshash = {}
    for condition in @conditions
      condition['parent_id'] = @childToParentMap[condition.id.to_i].to_i
      tshash[condition['parent_id']]  = ' '  if(condition['is_time_series'])
    end
    @numTS = tshash.keys.length #this can't be the # of time series
  end        

  def self.sort_conditions()
    @conditions.sort! do |a,b|
      if (a['parent_id'] == b['parent_id'])
        a.orig_sequence <=> b.orig_sequence
      else
        a['parent_id']  <=> b['parent_id']
      end
    end
  end

  def self.add_properties  
    for condition in @conditions
      data = {}
      props = Property.find_by_sql("select name, value from properties where condition_id = #{condition.id} and property_type in(1,2)") 
      condition['is_time_series'] = false
      for prop in props  
        #puts "WHOA!!!!!" if condition.name =~ /^o2_set1_/ and prop.name == 'time'
        condition['is_time_series']  = true if prop.name == 'time'
        data[prop.name] = prop.value
      end
      #if condition.name =~ /^o2_set1_/
      #  puts "#{condition.name} time series? #{condition['is_time_series']} id: #{condition.id}"
      #end                           
      condition['props'] = data
    end
  end

  def self.print_header()
    @colmap_file << "\tisTs\tis1stLast\tprevCol\tdelta.t\ttime\tts.ind\tnumTS\n"
  end                


  def self.generate_output()  
    ts_ind = 0              

    prev_cond = nil
    @conditions.each_with_index do |condition, i|

      if (i < @conditions.size)
        next_cond = @conditions[i+1]
      else
        next_cond = nil
      end


      ts = false
      ts = true if (condition['is_time_series'] == true)


      firstInSeries = true if prev_cond.nil?
      firstInSeries = true if ((!prev_cond.nil?) and (prev_cond['parent_id'] != condition['parent_id']))
      firstInSeries = false if ((!prev_cond.nil?) and (prev_cond['parent_id'] == condition['parent_id']))

      lastInSeries = false
      lastInSeries = true if (next_cond.nil?)
      lastInSeries = true if ((!next_cond.nil?) and (next_cond['parent_id'] != condition['parent_id']))


      prevCol = condition.name      
      if (ts)
        prevCol = prev_cond.name unless firstInSeries
      end

      middleOfSeries = false
      middleOfSeries = true if (!firstInSeries and !lastInSeries)

      is1stLast = "e"   
      is1stLast = "f" if firstInSeries and ts
      is1stLast = "m" if middleOfSeries and ts
      is1stLast = "l" if lastInSeries and ts    

      ts_ind += 1 if (firstInSeries and ts)

      #@colmap_file << condition['parent_id']; @colmap_file << "\t" # REMOVE THIS AFTER DEBUGGING  

      @colmap_file << condition.name
      @colmap_file << "\t"
      isTs = (ts) ? "TRUE" : "FALSE"
      isTs.strip!
      @colmap_file << isTs
      @colmap_file << "\t"

      @colmap_file << is1stLast
      @colmap_file << "\t"


      @colmap_file << prevCol
      @colmap_file << "\t"

      delta_t = "9999"
      if (ts)
        if (middleOfSeries or lastInSeries)
          delta_t = condition['props']['time'].to_i - prev_cond['props']['time'].to_i
        end
      end  



      @colmap_file << delta_t
      @colmap_file << "\t"

      time = "NA"
      if (ts)
        time = condition['props']['time']
      end                                
      @colmap_file << time
      @colmap_file << "\t"

      ts_ind_value = "NA"
      if (ts)
        ts_ind_value = ts_ind
      end

      @colmap_file << ts_ind_value
      @colmap_file << "\t"

      @colmap_file << @numTS
      @colmap_file << "\n"

      prev_cond = condition

    end
  end

  def self.main()
    read_conditions() 
    add_properties()  
    read_parents()
    sort_conditions()
    print_header()
    generate_output()
  end

  main()
end