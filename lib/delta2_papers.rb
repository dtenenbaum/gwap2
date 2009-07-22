class Delta2Papers
  f = File.open("#{RAILS_ROOT}/data/delta2_paper_association.txt")
  papers = Paper.find :all
  done = {}     
  
  begin
    Condition.transaction do
      while (line = f.gets)
        line.chomp!     
        next if line.nil? or line.empty?
        next if line =~ /unpublished$/
        citations = line.split("\t")
        cond_name = citations.shift
        cond = Condition.find_by_name(cond_name)
        exp = Experiment.find(cond.experiment_id)
        next if done.has_key?(exp.name)

        for citation in citations 
          citation = "Baliga, Biork, et al., 2004" if citation == "Baliga, 2004"
          paper = papers.detect{|i|i.short_name == citation}
          puts "adding paper #{citation} to exp #{cond_name}"
          exp.papers << paper
        end

        done[exp.name] = 1
      end
    end
  rescue Exception => ex
    puts ex.message
    puts ex.backtrace
  end
  
  
end