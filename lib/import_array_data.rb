class ImportArrayData
  require 'pp'
  genes = {}
  genelist = Gene.find :all
  for gene in genelist
    genes[gene.name] = gene.id
  end
  
  
  begin
    Feature.transaction do                                
      ######### warning! deleting data in features table!!!!!! do you really want to do this??????
      Feature.connection.execute("truncate table features")
      conditions = Condition.find :all     
      oldconds = Legacy.find_by_sql("select * from conditions")
      for cond in conditions 
##        next unless cond.name == 'o2__-001m_L2H_005' # comment me out!!!
        #puts "importing data for #{cond.name}..."
        #oldcond = Legacy.find_by_sql("select * from conditions where name = '#{cond.name}'").first
        oldcond = oldconds.detect{|i|i.name == cond.name}
        data = Legacy.find_by_sql("select * from tabular_data where condition_id = #{oldcond.id}")
        # do a check
        bad = data.find_all{|i|!genes.has_key?(i.row_name)}
        unless bad.empty?        
                                                            
          puts "warning: not importing data for condition: #{cond.name}"
          puts "because of bad gene names for #{cond.name}: #{bad.map{|i|i.row_name}.join(",")}"
          puts "number of rows: "
          puts "\tratios: #{data.find_all{|i|i.datatype.to_i == 1}.size}"
          puts "\tlambdas: #{data.find_all{|i|i.datatype.to_i == 2}.size}"
          puts "\terror: #{data.find_all{|i|i.datatype.to_i == 3}.size}"
          puts
          next
        end          
        
        #for item in data
          # just so happens that ratios = 1, lambdas = 2, and error = 3 in both dbs
          # old: condition_id, datatype, value, row_name
          # new: value, data_type, gene_id
          f = Feature.new(:condition_id => cond.id, :data_type => item.datatype, :value => item.value, :gene_id => genes[item.row_name])
          f.save
          #pp f
        #end
      end
    end
  rescue Exception => ex
    puts ex.message
    puts ex.backtrace
  end
  
  
  
end
