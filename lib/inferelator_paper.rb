class InferelatorPaper
  require 'pp'
  f = File.open("#{RAILS_ROOT}/data/conds_from_inferelator_paper.txt")
  condlist = []
  while (line = f.gets)
    num, cond = line.chomp.split(" ")
    condlist << cond
  end
  
  cell = Paper.find_by_short_name 'Bonneau, 2007'
  inf =  Paper.find_by_short_name 'Bonneau, 2006'
  
  exp_hash = {}
  condlist.each do |cond|
    exp = Experiment.find_by_sql(["select * from experiments where id = (select experiment_id from conditions where name = ?)",cond]).first
    puts "#{cond}!!!!!!!" if exp.nil?
    exp_hash[exp] = 1
  end
  
  begin
    Condition.transaction do
      exp_hash.keys.each do |exp|      
        puts "hello"
        pp exp
        unless exp.papers.include?(cell)
          exp.papers << cell
        end                 
        exp.papers << inf
      end
    end
  rescue Exception => ex
    puts ex.message
    puts ex.backtrace
  end
  
end