class LeeDeep
  #id      track_id        value   data_type       gene_id location_id     condition_id    sequence_id     start   end     strand  gene_name       condition_name
  # order: gene_name, condition_name
  
  unless ARGV.size == 1
    puts "supply a filename"
    exit
  end

  print "GENE\t"
  
  f = File.open(ARGV.first)
  
  cond_hash = {}
  
  lines = []
  
  while(line = f.gets)
    next if line =~ /^id/
    id, track_id, value, data_type, gene_id, location_id,  condition_id, sequence_id, start, _end, strand, gene_name, condition_name = line.chomp.split("\t")
    cond_hash[condition_name] = 1
    lines << [value, gene_name]
  end

  conds = cond_hash.keys.sort
  print conds.join("\t")
  print "\n"
      
  line = ""

  count = 1
  
  lines.inject([]) do |memo, i|
    value, gene_name = i
    mvalue, mgene_name = memo 
    
    #puts "#{value} #{gene_name} : #{mvalue} #{mgene_name}"
    
    
    puts line.gsub(/\t$/,"") if count == lines.size
    if (gene_name != mgene_name)
      puts line.gsub(/\t$/,"") unless mvalue.nil?
      line = ""
      line << gene_name
      line << "\t"
    else
    end
    line << value
    line << "\t"
    count += 1
    i
  end



  
end