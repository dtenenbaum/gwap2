class MainController < ApplicationController
  
  before_filter :authenticate, :except => :login
  filter_parameter_logging :password

  
  require 'pp'
#  require 'CGI'

def authenticate  
  puts "in authenticate"
  if cookies[:gwap2_cookie].nil? or cookies[:gwap2_cookie].empty?
    puts "cookie doesn't exist"
    redirect_to :action => "login" and return false
  end
  if (session[:user].nil?)    
    puts "session user is not set"
    puts "cookie is set to #{cookies[:gwap2_cookie]}"
    session[:user] = User.find_by_email(cookies[:gwap2_cookie])
  end
end                              

# todo make more secure
def login
  if request.post?
    user = User.authenticate(params['email'],params['password'])     
    #render :text => user.email and return false
    if (user == false)
      flash[:notice] = "Invalid login, try again"
      render :action => "login" and return false
    else              
      cookies[:gwap2_cookie] = {:value => user.email,
        :expires => 1000.days.from_now }
      session[:user] = user
      redirect_to :action => "index"
    end
  end
end

def logout
  cookies.delete(:gwap2_cookie)
  session[:user] = nil  
  redirect_to :action => "login"
end




  
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
   exp = Experiment.find params[:id]
     columns, maxrange, minrange, h, rejected_columns = SparklineHelper.get_sparkline_info(exp.id)
     render(:partial => "single_sparkline", :locals => {
       :exp => exp, :columns => columns, :h => h, :maxrange => maxrange, :minrange => minrange
     })
 end                                              
 
 def gene_search                                                         
   exp_ids = params['exps'].split(",")
   @matches, @proteins = SearchHelper.full_search(params['search'])
   
   #@annos = AnnotationHelper.get_annotations(@proteins)
   #colnames, rows = ExpressionHelper.get_expr_data(@proteins, exp_ids)
   #@heatmap = VisHelper.matrix_as_google_response(colnames,rows, "gene_name","GENE")
   #colnames, rows = ExpressionHelper.get_expr_data(@proteins, exp_ids, false)
   #@plot = VisHelper.matrix_as_google_response(colnames, rows, "condition_name", "CONDITION")
   #@network = NetworkHelper.get_network(@proteins)
   render :partial => "gene_search"
 end                   
 
 
 def annotations
   exp_ids = params['exps'].split(",")
   @matches, @proteins = SearchHelper.full_search(params['search'])
   @annos = AnnotationHelper.get_annotations(@proteins)
   render(:partial => "annotations", :locals => {:annotations => @annos})
 end     
 
 def heatmap
   exp_ids = params['exps'].split(",")
   @matches, @proteins = SearchHelper.full_search(params['search'])
   colnames, rows = ExpressionHelper.get_expr_data(@proteins, exp_ids)
   @heatmap = VisHelper.matrix_as_google_response(colnames,rows, "gene_name","GENE")
   render(:partial => "heatmap", :locals => {:data => @heatmap})
 end

 def table
   exp_ids = params['exps'].split(",")
   @matches, @proteins = SearchHelper.full_search(params['search'])
   colnames, rows = ExpressionHelper.get_expr_data(@proteins, exp_ids)
   @table = VisHelper.matrix_as_google_response(colnames,rows, "gene_name","GENE")
   render(:partial => "table", :locals => {:data => @table})
 end       
 
 def plot
   exp_ids = params['exps'].split(",")
   @matches, @proteins = SearchHelper.full_search(params['search'])
   colnames, rows = ExpressionHelper.get_expr_data(@proteins, exp_ids)
   @plot = VisHelper.matrix_as_google_response(colnames, rows, "condition_name", "CONDITION")
   render(:partial => "plot", :locals => {:data => @plot})
 end       
 
 def network
   exp_ids = params['exps'].split(",")
   @matches, @proteins = SearchHelper.full_search(params['search'])
   @network = NetworkHelper.get_network(@proteins)
   render(:partial => "network", :locals => {:data => @network})
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
   @tag_categories = TagCategory.find :all, :order => 'category_name'
   #@exps = Experiment.find(:all)
 end
 
 def add_experiment_tag
   # todo - should show a warning, or disallow adding tag, if user tries to add tag with the same name as an auto-generated tag
   # or does that not make sense? (it would complicate displaying auto tags differently from manual tags)
   ExperimentTag.new(:experiment_id => params[:id], :tag => params['tag'], :auto => false, :is_alias => false, :alias_for => params['tag']).save
   experiment_tags = ExperimentTag.find_all_by_experiment_id(params[:id], :all, :order => 'tag')
   render :partial => "experiment_tags", :locals => {:tags => experiment_tags}
 end   
 
 def get_gwap1_ids
   exp_ids = params[:exp_ids].gsub(/,$/, "")
   gwap1_ids = Experiment.find_by_sql(["select gwap1_id from experiments where id in (?)",exp_ids.split(",")]).map{|i|i.gwap1_id}
   ret = "var gwap_url = 'http://gaggle.systemsbiology.net:/GWAP/dmv/dynamic.jnlp?host=gaggle.systemsbiology.net&port=&exps=#{gwap1_ids.join(",")}';"
   render :text => ret
 end
 
 def experiment_detail
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
 
 def inclusive_search
   raw_tags = params['tags'].gsub(/\#\#$/,"")
   tags = raw_tags.split("##")
   sql = <<"EOF"
   select * from experiments where id in (
       select experiment_id from experiment_tags where tag in (?)
   ) order by name
EOF
   @exps = Experiment.find_by_sql([sql,tags])
   @sparklines = []                   
   exp_cond_nums = {}
   for exp in @exps
     columns, maxrange, minrange, h, rejected_columns = SparklineHelper.get_sparkline_info(exp.id)
     sparkline = render_to_string(:partial => "sparkline", :locals => {
       :exp => exp, :columns => columns, :h => h, :maxrange => maxrange, :minrange => minrange
     })
     @sparklines << sparkline
     exp_cond_nums[exp.id.to_s] = exp.conditions.size
     
   end
   
   render :partial => "inclusive_search", :locals => {:exps => @exps, :sparklines => @sparklines, :rejected_columns => rejected_columns,
     :exp_cond_nums => exp_cond_nums.to_json, :tags => tags}
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
   constraints = segs.last.gsub(/,$/,"").split("::")
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
   @tag_categories = TagCategory.find :all, :order => 'category_name'
   @selected_tags = params[:id].split("::")      
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
   same_results = []
   @exps.inject do |memo, exp|
     a = exp.experiment_tags.map{|i|i.tag}.sort
     b = memo.experiment_tags.map{|i|i.tag}.sort
     same_results.push((a == b))  
     exp
   end
   different = (same_results.detect{|i|i == false})    
   
   
   sql =<<"EOF"
   select distinct tag, auto from experiment_tags where alias_for not in (select distinct alias_for from experiment_tags where tag in (?)) 
   and experiment_id in (?)
   order by tag
EOF
   if (@exps.size == 1 or different) # if you can't refine any more
     @remaining_tags = []
   else
     @remaining_tags = Experiment.find_by_sql([sql,@selected_tags,@exps.map{|i|i.id}])
   end
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
