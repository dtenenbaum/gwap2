class GetSlideNums
  # todo finish this
#  conds = Condition.find :all  
  exps = Experiment.find :all
  
  path = "/Volumes/Arrays/Pipeline/output/project_id/"
  
  begin
    Condition.transaction do
      for exp in exps 
        next if exp.sbeams_project_id.nil?
        next if exp.sbeams_project_timestamp.nil?  # for now
        exp.conditions.each_with_index do |cond, index| 
          next unless cond.name.downcase =~ /pq|h2o2/
          next unless cond.forward_slide_number.nil?
          filename = "#{path}#{exp.sbeams_project_id}/#{exp.sbeams_project_timestamp}/#{cond.name.gsub(/\.sig$/,"")}.ft"
          if (Kernel.test(?f, filename))
            #puts "#{filename} totally found!!!"
          else                        
            # there may be another way to tackle these later
            #puts "#{filename} unfound"         
            plok = `ls -1 #{path}#{exp.sbeams_project_id}/#{exp.sbeams_project_timestamp}/*.sig`
            next if plok.empty?
            old_cond_names = plok.split("\n")      
            #old_cond_names = []
            #raw_old_cond_names.each do |i|
            #  old_cond_names << i.split("/").last
            #end 
            next if old_cond_names[index] =~ /^C/
            puts "#{old_cond_names[index]}\t#{cond.name}"
            filename = old_cond_names[index].gsub(/\.sig$/,".ft")
            exists = Kernel.test(?f, filename)
            #puts "#{exists} #{filename}"
            
          end

          f = File.open(filename)
          while (line = f.gets)         
            num = line.split(".").first
            cond.forward_slide_number = num  if (line =~ /\tf\t1/)
            cond.reverse_slide_number = num  if (line =~ /\tr\t2/)
          end
          puts "#{filename} f: #{cond.forward_slide_number} r: #{cond.reverse_slide_number}"
          cond.save



        end
      end
    end
  rescue Exception => ex
    puts ex.message
    puts ex.backtrace
  end
  
  
  
end