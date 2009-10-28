class VisHelper
   def self.matrix_as_google_response(colnames, matrix, row_function, rowTitlesTitle="GENE")
    table = {}
    cols = []    
    cols << {'label' => rowTitlesTitle, 'type' => 'string'}        
    
    col_function = (row_function == 'gene_name') ? "condition_name" : "gene_name"
                                        
    all_col_names = []
    for row in matrix
      for item in row
        all_col_names << item.send(col_function)
      end
    end
    all_col_names = all_col_names.uniq
    
    
    
    colnames.each do |col|
      next unless all_col_names.include? col
      cols << {'label' => "#{col}", 'type' => 'string'}
    end
    table['cols'] = cols
    rows = []
    for line in matrix
      row = {}
      cells = []                                      
      #puts "ROWFUNC = #{line.first.send(row_function)}"
      cells << {'v' => line.first.send(row_function)}
      line.each_with_index do |thing, i| 
        value = thing.value.to_f
        c = {'v' => value}
        cells.push c
      end
      bla = {'c' => cells}
      rows.push bla
    end            
    table['rows'] = rows
    table.to_json
  end
  
end