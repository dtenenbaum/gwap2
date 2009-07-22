class GetCitations
  f = File.open("#{RAILS_ROOT}/out")
  conds = []
  while (line = f.gets)
    conds << line.chomp
  end                  
  conds.each do |cond_name|
    cond = Condition.find_by_name(cond_name)
    exp = Experiment.find(cond.experiment_id)
    papes = []
    if exp.papers.size > 0
      exp.papers.each{|i| papes << i.short_name }
    end
    puts "#{cond_name}\t #{papes.join("\t")}"
  end
end