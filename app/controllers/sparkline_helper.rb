class SparklineHelper      
  
  

  def self.get_columns_for_sparkline(exp)
    cols = []    
    all_cols = []
    for ob in exp.conditions.first.observations
      cols << ob.name unless (ob.float_value.nil? or  !ob.float_value.is_a?(Numeric) or  ob.name == 'time')
      all_cols << ob.name
    end   
    rejected_cols = all_cols - cols   
    rejected_cols -= ['time','clockTime']
    return cols.sort, rejected_cols.sort
  end


  def self.get_sparkline_info(exp_id, normalized=true)         
    has_nan = false
    exp = Experiment.find(:first, :conditions => "id = #{exp_id}", :order => 'name', :include =>[{:conditions=>:observations}])
    columns, rejected_columns = get_columns_for_sparkline(exp)
    h = {}
    minrange = []
    maxrange = []
    min = max = nil
    for col in columns
      row = []
      nrow = []
      all = []
      minrange << 0
      maxrange << 1 
      for cond in exp.conditions
        for ob in cond.observations
          if (ob.name == col)                     
            min = max = ob.float_value if min.nil?
            min = ob.float_value if min > ob.float_value
            max = ob.float_value if max < ob.float_value
            row << ob.float_value #(ob.float_value.nil?) ? ob.int_value : ob.float_value
            has_nan = true if ob.float_value == 'nan'
          end
        end
      end       
      row.each{|i| nrow << sprintf("%.3f", normalize(i,min,max))}
        if (normalized)
          h[col] = nrow
        else
          h[col] = row
        end
      end
      #render_to_string :layout => false, :partial => 'nothing', :locals => {:exp => exp, :columns => columns, :h => h, :minrange => minrange, 
      #  :maxrange => maxrange}
      return columns, maxrange, minrange, h, rejected_columns, has_nan
  end 
  
  def self.normalize(x, min, max, nscale_min=0.0, nscale_max=1.0)
    return 0 if (min == 0 and max == 0)
    x = x.to_f
    min = min.to_f  
    max = max.to_f
    nscale_min = nscale_min.to_f
    nscale_min = nscale_min.to_f
    result = ((nscale_max-nscale_min)/(max-min))*(x-min) + nscale_min
    #puts  "x = #{x}, min = #{min}, max = #{max}, result = #{result}"
    result
  end   
  
  
end