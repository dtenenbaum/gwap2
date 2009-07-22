class PaperFixes
  require 'pp'
  
  all_exps = Experiment.find :all
  nopapers = all_exps.find_all{|i|i.papers.empty?}
  haspapers = all_exps.reject{|i|i.papers.empty?}
  
  marc = Paper.find_by_short_name('Facciotti, 2007')
  h2o2 = Paper.find_by_short_name("Kaur, in prep")
  amy_o2 = Paper.find_by_short_name("Schmid, 2007")
  
  begin
    Experiment.transaction do
      for e in nopapers
        puts e.name
#        e.papers << marc if e.name.downcase =~ /marc|tbp|tfp/
#        e.papers << h2o2 if e.name.downcase =~ /h2o2|paraquat/
#        e.papers << amy_o2 if e.name.downcase =~ /fermentor/




      end
    end
    
    
    # remove dupes
    for e in haspapers
      pp e
      pp e.papers
      h = {}
      for p in e.papers
        h[p] = 1
      end
      e.papers = []
      #puts "size = #{e.papers.size}"
      #exit if true
      h.each_key do |k|
        e.papers << k
      end
    end
    
  rescue Exception => ex
    puts ex.message
    puts ex.backtrace
  end
  
  
  
end