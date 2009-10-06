class FixMismatches
  require 'pp'
  begin  
    
    conds = Condition.find :all
    condmap = {}
    conds.each{|i|condmap[i.name] = i.id}
    
    genes = Gene.find :all
    genemap = {}
    genes.each{|i|genemap[i.name]=i.id}
    
    Condition.transaction do
      IO.foreach("/Users/dtenenbaum/dev/backend_schema/mismatch.log.bak") do |line|
        next unless line =~ /^mismatch/   
        #mismatch: Zn_0.015_vs_NRC-1d.sig:  new value: -0.187 old value: -0.113 datatype: 1 row: VNG1101C
        #mismatch:Zn_0.015_vs_NRC-1d.sig: newvalue:-0.187 old value: -0.113 datatype: 1 row: VNG1101C
        line =~ /mismatch: ([^:]*)/
        cond = $1
        line =~ /new value: ([^ ]*)/
        newvalue = $1.to_f
        line =~ /old value: ([^ ]*)/
        oldvalue = $1.to_f
        line =~ /datatype: ([^ ]*)/
        datatype = $1
        line.chomp =~ /row: ([\w]*)$/
        row = $1
        begin
          Kernel.Float(newvalue)
        rescue
          puts "skipping because of #{newvalue}"
          next
        end                                                  
      
       #ac = TabularDatum.find :first, :conditions => "condition_id = #{condmap[cond]} and value = #{newvalue} and row_name = '#{row}' and datatype = #{datatype}"
       #unless ac.nil?
       #  puts "this has already been corrected, skipping...."
       #  next
       #end       
       unless genemap.has_key?(row)
         #puts "no such gene: #{row}"
         next
       end
        f = Feature.find :first, :conditions => "condition_id = #{condmap[cond]} and gene_id = #{genemap[row]} and data_type = #{datatype}"
        if f.nil?
          #puts "WARNING! not found! cond:#{cond}\tnewvalue:#{newvalue}\toldvalue:#{oldvalue}\t\tdatatype:#{datatype}\trow:#{row}"
          #t2 = TabularDatum.find :first, :conditions => "condition_id = #{condmap[cond]} and  row_name = '#{row}' and datatype = #{datatype}"
          #if t2.nil?
          #  puts "didn't find it with any value"
          #else
          #  puts "however, it was found with value #{t2.value}"
          #end
          next
        end
#        puts "#{cond}\t#{newvalue}\t#{oldvalue}\t#{datatype}\t#{row}"
        #puts "actual value is #{f.value}, oldvalue = #{oldvalue}, newvalue = #{newvalue}"
        if (f.value != oldvalue)
          #puts "mismatch! expected #{oldvalue} but found #{f.value}"     
        else
          puts "updating cond:#{cond}\tnewvalue:#{newvalue}\toldvalue:#{oldvalue}\t\tdatatype:#{datatype}\trow:#{row}"
          f.value = newvalue
          #pp f             
          
          f.save
        end
      end
    end
  rescue Exception => ex
    puts ex.message
    puts ex.backtrace
  end
  
end