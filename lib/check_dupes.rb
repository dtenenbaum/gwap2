class CheckDupes
  sql = <<"EOF"
  select c1.* from conditions c1, conditions c2
  where c1.forward_slide_number = c2.forward_slide_number
  and c1.forward_slide_number is not null
  and c1.id != c2.id
  order by forward_slide_number
EOF
  dupes = Condition.find_by_sql [sql]
  
  mapfile = File.open("#{RAILS_ROOT}/pq_names")
  linez = mapfile.readlines
  map = {}
  linez.each do |line|
    old,new = line.chomp.split("=")
    map[old] = new
  end
  

  begin
    Condition.transaction do
      for dupe in dupes
        change = false
        exp = Experiment.find dupe.experiment_id
        dir = "/Volumes/Arrays/Pipeline/output/project_id/#{exp.sbeams_project_id}/#{exp.sbeams_project_timestamp}"
        #puts dir; exit if true
        #name = dupe.name.gsub(/_set_[0-9]_/, "_")   
        #name.gsub!(/\.sig$/,"")
        #str =  `cat #{dir}/#{name}.ft`   
        name = map[dupe.name]
        filename = "#{dir}/#{name}"
        next unless test(?f, filename) # fixed these already
        #puts filename
        f = File.open(filename)
        lines = f.readlines
        fsn = lines.first.split(".").first.to_i
        rsn = lines.last.split(".").first.to_i
        puts "FSN match: #{dupe.forward_slide_number == fsn} DB: #{dupe.forward_slide_number} FS: #{fsn}"
        puts "RSN match: #{dupe.reverse_slide_number == rsn} DB: #{dupe.reverse_slide_number} FS: #{rsn}"
        if (dupe.forward_slide_number != fsn)
          existing_f = Condition.find_all_by_forward_slide_number(fsn)
          if existing_f.empty?
            dupe.forward_slide_number = fsn
            change = true
          else
            #puts "BZZZZ! This FSN exists in the db already!!!!!!"
          end
        end

        if (dupe.reverse_slide_number != rsn)
          existing_r = Condition.find_all_by_reverse_slide_number(rsn)
          if existing_r.empty?
            dupe.reverse_slide_number = rsn
            change = true
          else
            #puts "BZZZZ! This RSN exists in the db already!!!!!!"
          end
        end

        dupe.save if change



        #puts filename
        #puts "Cond name = #{dupe.name}"
        #duh  = Dir.new(dir)
        #fts = duh.each do |item|
        #  puts "\t#{item}" if item =~ /\.ft$/
        #end
      end
    end
  rescue Exception => ex
    puts ex.message
    puts ex.backtrace
  end


  
  
  
  #i = 0
  #dupes.inject do |mem, dupe|
  #  count = Feature.find_by_sql(["select value from features where condition_id = ? order by value",dupe.id]).map{|x|x.value}
  #  if (i % 2) == 1
  #    puts "match? #{mem == count}"
  #  end  
  #  i += 1
  #  count
  #end
  
  
end

__END__
f = File.open(filename)
lines = f.readlines
fsn = lines.first.split(".").first.to_i
rsn = lines.last.split(".").first.to_i
puts "FSN match: #{dupe.forward_slide_number == fsn} DB: #{dupe.forward_slide_number} FS: #{fsn}"
puts "RSN match: #{dupe.reverse_slide_number == rsn} DB: #{dupe.reverse_slide_number} FS: #{rsn}"
if (dupe.forward_slide_number != fsn)
  existing_f = Condition.find_all_by_forward_slide_number(fsn)
  if existing_f.empty?
    dupe.forward_slide_number = fsn
    change = true
  else
    puts "BZZZZ! This FSN exists in the db already!!!!!!"
  end
end

if (dupe.reverse_slide_number != rsn)
  existing_r = Condition.find_all_by_reverse_slide_number(rsn)
  if existing_r.empty?
    dupe.reverse_slide_number = rsn
    change = true
  else
    puts "BZZZZ! This RSN exists in the db already!!!!!!"
  end
end

dupe.save if change
