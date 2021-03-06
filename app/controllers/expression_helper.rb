class ExpressionHelper
    


    def self.get_expr_data_for_conditions(gene_list, condition_ids, for_heatmap=true)
      conds = Condition.find :all, :conditions => ["id in (?)", condition_ids]
      actually_get_data(gene_list, conds, for_heatmap)
    end
    
    def self.actually_get_data(gene_list, conds, for_heatmap=true)
             # todo this could fail if user manually types in lowercase gene name
             gene_list.each_with_index do |item, i|
               gene_list[i].gsub!(/[a-z]+$/,"") if item.downcase =~ /^vng/
             end




             rows = []                                       
             if (for_heatmap) # it seems that for_heatmap is never anything but true. todo: verify and clean up accordingly
               sql = <<EOF
               select f.*, g.name as gene_name, c.name as condition_name from features f, genes g, conditions c
               where f.gene_id = g.id                                                                          
               and f.condition_id = c.id
               and g.name in (?)
               and f.condition_id in (?)    
               and f.data_type = 1
               order by g.name, f.condition_id
EOF
               values = Feature.find_by_sql([sql, gene_list, conds.collect{|i|i.id}])
      #         values = Matrix.find_by_sql(["select * from matrices where condition_id in (?) " + 
      #           " and gene_name in (?) order by gene_name, condition_id",conds.collect{|i|i.id},gene_list])
               colnames = conds.collect{|c|c.name}
               values.each_slice(colnames.size) {|row| rows << row}  
               return colnames, rows                            
             else
               sql = <<EOF
               select g.name as gene_name, f.value, c.name as condition_name
               from features f, genes g, conditions c
               where c.id = f.condition_id
               and f.gene_id = g.id
               and g.name in (?)
               and f.condition_id in (?)
               and f.data_type = 1
               order by c.name, c.sequence, g.name
EOF
               values = Feature.find_by_sql([sql,gene_list, conds.collect{|i|i.id}])
               colnames = values.map{|v|v.gene_name}.sort.uniq
               if (colnames.size > 0)
                 values.each_slice(colnames.size) do |row|
                   rows << row
                 end
               end
               return colnames, rows
             end
    end
    
    
    def self.get_expr_data_for_experiments(gene_list, experiment_ids, for_heatmap=true)

      conds = Condition.find :all, :conditions => ["experiment_id in (?)", experiment_ids], :order => 'experiment_id, sequence'
      actually_get_data(gene_list, conds, for_heatmap)

    end


end