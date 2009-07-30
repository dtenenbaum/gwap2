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
        for cond in exp.conditions
          filename = "#{path}#{exp.sbeams_project_id}/#{exp.sbeams_project_timestamp}/#{cond.name.gsub(/\.sig$/,"")}.ft"
          if (Kernel.test(?f, filename))
            #puts "#{filename} totally found!!!"
            f = File.open(filename)
            while (line = f.gets)         
              num = line.split(".").first
              cond.forward_slide_number = num  if (line =~ /\tf\t1/)
              cond.reverse_slide_number = num  if (line =~ /\tr\t2/)
            end
            #puts "#{filename} f: #{cond.forward_slide_number} r: #{cond.reverse_slide_number}"
            cond.save
          else                        
            # there may be another way to tackle these later
            #puts "#{filename} unfound"
          end
        end
      end
    end
  rescue Exception => ex
    puts ex.message
    puts ex.backtrace
  end
  
  
  
end