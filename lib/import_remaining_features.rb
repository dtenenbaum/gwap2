class ImportRemainingFeatures
  # this class name is a misnomer....actually it imports everything that uses the canonical list of genes. it leaves out everything else.
  # need to deal with that at a later time.
  require 'pp'
  remaining = []
  for cond in Condition.find :all
    size = Feature.find_by_sql(["select count(*) as result from features where condition_id = ?", cond.id]).first.result.to_i
    
    remaining << cond if size == 0
  end
  

  genes = {}
  genelist = Gene.find :all
  for gene in genelist
    genes[gene.name] = gene.id
  end                            

  Feature.transaction do
    begin
      for cond in remaining
        puts "#{cond.name}...."
        oldcond = Legacy.find_by_sql("select * from conditions where name = '#{cond.name}'").first
        data = Legacy.find_by_sql("select * from tabular_data where condition_id = #{oldcond.id}")
        for item in data
          # just so happens that ratios = 1, lambdas = 2, and error = 3 in both dbs
          # old: condition_id, datatype, value, row_name
          # new: value, data_type, gene_id
          f = Feature.new(:condition_id => cond.id, :data_type => item.datatype, :value => item.value, :gene_id => genes[item.row_name])
          #pp f       
          unless genes.has_key?(item.row_name)
            puts "WHOOPS!"
            break
          end
          f.save
        end
      end
    rescue Exception => ex
      puts ex.message
      puts ex.backtrace
    end
  end


  
end