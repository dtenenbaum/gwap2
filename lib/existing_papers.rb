class ExistingPapers
  f = File.open("#{RAILS_ROOT}/data/papers.tsv")
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
        puts "this exp has #{exp.papers.size} papers already"
        next if done.has_key?(exp.name)

        for citation in citations 
          citation = "Baliga, Biork, et al., 2004" if citation == "Baliga, 2004"
          paper = papers.detect{|i|i.short_name == citation}     
          already = nil
          already = exp.papers.detect{|i|i.short_name == citation}
          if already.nil?
            puts "adding paper #{citation} to exp #{cond_name}"
            exp.papers << paper
          end
        end

        done[exp.name] = 1
      end
    end
  rescue Exception => ex
    puts ex.message
    puts ex.backtrace
  end
  
  
end