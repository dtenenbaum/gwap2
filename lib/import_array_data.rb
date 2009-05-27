class ImportArrayData
  require 'pp'
  genes = {}
  genelist = Gene.find :all
  for gene in genelist
    genes[gene.name] = gene.id
  end
  
  conditions = Condition.find :all
  for cond in conditions
    oldcond = Legacy.find_by_sql("select * from conditions where name = '#{cond.name}'").first
    data = Legacy.find_by_sql("select * from tabular_data where condition_id = #{oldcond.id}")
    for item in data
      # just so happens that ratios = 1, lambdas = 2, and error = 3 in both dbs
      # old: condition_id, datatype, value, row_name
      # new: value, data_type, gene_id
      f = Feature.new(:condition_id => cond.id, :data_type => item.datatype, :value => item.value, :gene_id => genes[item.row_name])
      f.save
      #pp f
      puts "WHOOPS!" unless genes.has_key?(item.row_name)
    end
  end
end
