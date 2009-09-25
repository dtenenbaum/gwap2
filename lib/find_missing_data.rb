class FindMissingData
  require 'pp'
  missing_conds = []
  for cond in Condition.find :all
    count = Condition.find_by_sql(["select count(*) as result from features where condition_id = ?",cond.id]).map{|i|i.result}.first
    missing_conds << cond  if count.to_i == 0
  end              
#  pp missing_conds
#  puts missing_conds.size
#  exit if true

  genes = {}
  genelist = Gene.find :all
  for gene in genelist
    genes[gene.name] = gene.id
  end                            

  bad_stuff = {}
  
  Feature.transaction do
    begin
      for cond in missing_conds
        #puts "importing data for #{cond.name}..."
        oldcond = Legacy.find_by_sql("select * from conditions where name = '#{cond.name}'").first
        data = Legacy.find_by_sql("select * from tabular_data where condition_id = #{oldcond.id}")
        for item in data
          # just so happens that ratios = 1, lambdas = 2, and error = 3 in both dbs
          # old: condition_id, datatype, value, row_name
          # new: value, data_type, gene_id
          f = Feature.new(:condition_id => cond.id, :data_type => item.datatype, :value => item.value, :gene_id => genes[item.row_name])
          #f.save
          #pp f                               
          #unless genes.has_key?(item.row_name)
          #saved = item.row_name.dup
          item.row_name.gsub!(/[a-z]{1}$/,"")
          #end
          #puts "#{item.row_name}" unless genes.has_key?(item.row_name)
          bad_stuff[item.row_name] = 1
        end
      end 
      puts bad_stuff.keys.join("\n")
#      raise 'cain'
    rescue Exception => ex
      puts ex.message
      puts ex.backtrace
    end
  end
  
  
  
end