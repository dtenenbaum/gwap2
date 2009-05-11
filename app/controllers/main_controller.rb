class MainController < ApplicationController
  require 'pp'
  
  def swf
    redirect_to "/gwap2_take2.html"
  end   
  
  def all_exps
    render :text => Experiment.find(:all, :order => 'id').to_json
  end   
  
    
 def sparktest
   #@exp = Experiment.find(:first, :conditions => 'id = 5', :order => 'name', :include =>[{:conditions=>:observations}])
   #@columns = get_columns(@exp)
   #render :action => 'sparktest', :layout => false
   
   @exp = Experiment.find(:first, :conditions => "id = #{params[:id]}", :order => 'name', :include =>[{:conditions=>:observations}])
   @columns = get_columns(@exp)
   @h = {}
   @minrange = []
   @maxrange = []
   @min = @max = nil
   for col in @columns
     row = []
     nrow = []
     all = []
     @minrange << 0
     @maxrange << 1 
     for cond in @exp.conditions
       for ob in cond.observations
         if (ob.name == col) 
           @min = @max = ob.float_value if @min.nil?
           @min = ob.float_value if @min > ob.float_value
           @max = ob.float_value if @max < ob.float_value
           row << ob.float_value #(ob.float_value.nil?) ? ob.int_value : ob.float_value
         end
       end
     end       
     row.each{|i| nrow << sprintf("%.3f", normalize(i,@min,@max))}
     #puts "---"
     nrow.each{|i|puts "WHOA " if i == 0.0 or i == 1.0}
     
     if (params['normalized'] == 'true')
       @h[col] = nrow
     else
       @h[col] = row
     end
     #pp @h
   end
   render :action => 'sparktest', :layout => false
 end                                              
 
                              
 def get_columns(exp)
   cols = []
   for ob in exp.conditions.first.observations
     cols << ob.name unless (ob.float_value.nil? or ob.name == 'time')
   end   
   cols
 end
 
 
 def show_all_exps
   @exps = Experiment.find(:all, :order => 'name', :include =>[{:conditions=>:observations}])
 end      
 
 def get_cond
   @conds = Condition.find_by_sql(["select * from condi"])
   render :text => @cond.nil?
 end
  
  def static
    json = <<"EOF"
[[{"data":[{"name":"Cu","units":"mM","value":5, "nvalue":0.5},{"name":"Mn","units":"g","value":50,"nvalue":1.5}],"time":10}],[{"data":[{"name":"Cu","units":"mM","value":20,"nvalue":2.5},{"name":"Mn","units":"g","value":30,"nvalue":3.5}],"time":20}]]
EOF
    render :text => json
  end
  
  def dynamic
    # exp 64
    exp_id = 64
    exp = Experiment.find(exp_id)
    conds = exp.conditions
    data = []
    for cond in conds
      obs = cond.observations
      sql = <<"EOF"
        select l.name, o.float_value as value, u.name as units from controlled_vocab_items l, observations o, units u
        where o.name_id = l.id
        and o.units_id = u.id and o.float_value is not null
        and o.condition_id = #{cond.id}
EOF
      obs = Observation.find_by_sql(sql)
      time = obs.detect{|ob|ob.name == 'time'}.value
      outer = {'time' => time.to_i}
      tmp = []
      for ob in obs
        next if ob.name == 'time'
        h = {'name' => ob.name, 'value' => ob.value.to_f, 'units' => ob.units} #ob.units
        tmp.push h
      end
      outer['data'] = tmp
      data << [outer]
    end 
    hnorm(data)
    # cool, now normalize it
    
    render :text => data.to_json
  end  
  
  def hnorm(data)
    minmax = {}
    for timepoint in data
      for bla in timepoint
        #puts "HELLO!!!!!!!!! #{bla['time']}" 
        for item in bla['data']
          minmax[item['name']] = [] if minmax[item['name']].nil?
          minmax[item['name']] << item['value']
        end
      end
    end 
    #pp minmax
    tmp = []                
    minmax.each_key do |item|
      min = minmax[item].min
      max = minmax[item].max
      minmax[item] = [min,max]
    end                        
    
    for timepoint in data
      for bla in timepoint
        for item in bla['data']
          n = normalize(item['value'], minmax[item['name']].first, minmax[item['name']].last)
          item['nvalue'] = n.to_f
        end
      end
    end

    #puts "done normalizing"
    #pp data
    return data
  end
  
  
  def is_time_series(exp_id)
    exp = Experiment.find(exp_id)
    conds = exp.conditions
    obs = conds.first.observations
    res = obs.detect{|ob|ob.name == time}
    #todo finish
  end  
  
  def non_time_series
    # 54 - metal experiment
  end
        
  
  def normalize(x, min, max, nscale_min=0.0, nscale_max=1.0)
    x = x.to_f
    min = min.to_f  
    max = max.to_f
    nscale_min = nscale_min.to_f
    nscale_min = nscale_min.to_f
    result = ((nscale_max-nscale_min)/(max-min))*(x-min) + nscale_min
    #puts  "x = #{x}, min = #{min}, max = #{max}, result = #{result}"
    result
  end   
  

  

  def self.norm(a)
    ret = []
    for item in a
      ret << normalize(item, a.min, a.max)
    end
    ret
  end
  
  
end
