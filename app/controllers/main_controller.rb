class MainController < ApplicationController
  require 'pp'
#  require 'CGI'
  
  def swf
    redirect_to "/gwap2_take2.html"
  end   
  
  def all_exps
    render :text => Experiment.find(:all, :order => 'id').to_json
  end   
  
  def dmv_jnlp
#    render 
  end
 
 def spark
   render(:template => "main/sparky", :layout => false) and return false
 end
    
 def sparkline()
   normalized = true
   
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
     if (normalized)
       @h[col] = nrow
     else
       @h[col] = row
     end
   end
   render :partial => 'sparkline'
 end                                              
 
 def search                                                         
   exp_ids = params['exps'].split(",")
   @matches, @proteins = SearchHelper.full_search(params['search'])
   @annos = AnnotationHelper.get_annotations(@proteins)
   colnames, rows = ExpressionHelper.get_expr_data(@proteins, exp_ids)
   @heatmap = VisHelper.matrix_as_google_response(colnames,rows, "gene_name","GENE")
   colnames, rows = ExpressionHelper.get_expr_data(@proteins, exp_ids, false)
   @plot = VisHelper.matrix_as_google_response(colnames, rows, "condition_name", "CONDITION")
   @network = NetworkHelper.get_network(@proteins)
 end
                              
 def get_columns(exp)
   cols = []
   for ob in exp.conditions.first.observations
     cols << ob.name unless (ob.float_value.nil? or ob.name == 'time')
   end   
   cols
 end
 
 def test
   render :text => "hello"
 end
 
 def index
   redirect_to :action => 'show_all_exps'
 end
 
 def show_all_exps  #default action  
   @all_tags = ExperimentTag.find_by_sql("select distinct tag, auto from experiment_tags order by tag")
   @remaining_tags = @all_tags
   @exps = Experiment.find(:all, :order => 'name', :include =>[{:conditions=>:observations}])
   #@exps = Experiment.find(:all)
 end
 
 def add_experiment_tag
   # todo - should show a warning, or disallow adding tag, if user tries to add tag with the same name as an auto-generated tag
   # or does that not make sense? (it would complicate displaying auto tags differently from manual tags)
   ExperimentTag.new(:experiment_id => params[:id], :tag => params['tag'], :auto => false, :is_alias => false, :alias_for => params['tag']).save
   experiment_tags = ExperimentTag.find_all_by_experiment_id(params[:id], :all, :order => 'tag')
   render :partial => "experiment_tags", :locals => {:tags => experiment_tags}
 end 
          
 def old_tag_exps     
   response.content_type = "text/javascript"
   render :update do |page|
     page.replace_html "test", "<h1>yowza!</h1>"
   end
 end
 
 
 def tag_exps
   url = params['url'].gsub(/\#$/,"")
   segs = url.split("=")
   constraints = segs.last.gsub(/,$/,"").split(",")
   constraints = constraints.split("?id=").last
   #constraints = [params['id']]
   constraints << params['tag']      
   
   puts "constraints:"
   pp constraints
   puts "url = #{params['url']}"
   
   
   ids = params['ids'].gsub(/,$/,"").split(",");
   for id in ids
     ExperimentTag.new(:experiment_id => id, :tag => params['tag'], :auto => false, :is_alias => false, :alias_for => params['tag']).save     
   end
   all_tags = ExperimentTag.find_by_sql("select distinct tag, auto from experiment_tags order by tag")
   
   selected_tags = ExperimentTag.find_by_sql(["select distinct tag, auto from experiment_tags where tag in (?)",constraints])
   
   response.content_type = "text/javascript"
#   render :partial => "experiment_tags", :locals => {:tags => all_tags, :cumulative => false} 
#    render :partial => "selected_tags", :locals => {:selected_tags => selected_tags.map{|i|i.tag}}
#   return if true
   render :update do |page|
     page.replace_html "all_tags", :partial => "experiment_tags", :locals => {:tags => all_tags, :cumulative => false}
     page.replace_html "selected_tags", :partial => "selected_tags", :locals => {:selected_tags => selected_tags.map{|i|i.tag}}
   end
 end
 
 def find_experiments_by_tag
   @all_tags = ExperimentTag.find_by_sql("select distinct tag, is_alias, alias_for from experiment_tags order by tag")
   @selected_tags = params[:id].split(",")      
   sql =<<"EOF"
   select * from experiments where id in
   (
   select experiment_id from experiment_tags 
   where tag in (?)
   group by experiment_id
   having count(experiment_id) = ?
   ) order by name
              
EOF
   @exps = Experiment.find_by_sql([sql,@selected_tags,@selected_tags.size])                  
   sql = "select distinct tag, auto from experiment_tags where alias_for not in (select distinct alias_for from experiment_tags where tag in (?)) order by tag"                                                                                                                     
   @remaining_tags = Experiment.find_by_sql([sql,@selected_tags])
   puts "Selected tags: "
   pp @selected_tags
   render :action => 'show_all_exps'
 end

 
 
 def edit_exp
   @exp = Experiment.find(params[:id], :include =>[{:conditions=>:observations}]) 
   if (@exp.has_knockouts)
     k = @exp.knockouts.first
     @kos = [k] # just deal with single KOs for now
     while (true)
       k = k.parent
       break if k.nil?
       @kos << k
     end
     @kos.reverse!
     @kos.shift
   end
   obs = @exp.conditions.first.observations
   @non_numeric = []
   for ob in obs
     @non_numeric << ob.name if ob.float_value.nil?
   end                                             
   @non_numeric.sort!
   @non_numeric.uniq!     
   @exps = [@exp]
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
  

  

  def self.norm(a)
    ret = []
    for item in a
      ret << normalize(item, a.min, a.max)
    end
    ret
  end
  
  
end
