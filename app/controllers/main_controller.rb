class MainController < ApplicationController
  
  before_filter :authenticate, :except => :login
  filter_parameter_logging :password
  
  
  require 'pp'
#  require 'CGI'

def authenticate  
  puts "in authenticate"
  if cookies[:gwap2_cookie].nil? or cookies[:gwap2_cookie].empty?
    puts "cookie doesn't exist"
    redirect_to :action => "login", :url => request.url and return false
  end
  if (session[:user].nil?)    
    puts "session user is not set"
    puts "cookie is set to #{cookies[:gwap2_cookie]}"
    session[:user] = User.find_by_email(cookies[:gwap2_cookie])
  end
end                              

# todo make more secure
def login
  if request.get?
    session[:redir_url] = params[:url]
    unless (session[:user].nil?)
      redirect_to :action=> "index" and return false
    end
  else
    user = User.authenticate(params['email'],params['password'])     
    #render :text => user.email and return false
    if (user == false)
      flash[:notice] = "Invalid login, try again"
      render :action => "login" and return false
    else              
      cookies[:gwap2_cookie] = {:value => user.email,
        :expires => 1000.days.from_now }
      session[:user] = user   
      puts "url = #{session[:redir_url]}"      
      unless (session[:redir_url].nil?)
        puts "user had a url in mind"
        redirect_to session[:redir_url] and return false
      end
      puts "user had no url in mind"
      redirect_to :action => "index"
    end
  end
end

def logout
  cookies.delete(:gwap2_cookie)
  session[:user] = nil  
  redirect_to :action => "login"
end


def mockup
  cond_names = <<"EOF"
sDura3D1179_pCu_d0.100mM_t+015m_vs_NRC-1h1.sig
sDura3D1179_pCu_d0.100mM_t+030m_vs_NRC-1h1.sig
sDura3D1179_pCu_d0.100mM_t+060m_vs_NRC-1h1.sig
sDura3D1179_pCu_d0.100mM_t+180m_vs_NRC-1h1.sig
sDura3D1179_pCu_d0.100mM_t-015m_vs_NRC-1h1.sig
sDura3D1179_pCu_d0.700mM_t+015m_vs_NRC-1h1.sig
sDura3D1179_pCu_d0.700mM_t+030m_vs_NRC-1h1.sig
sDura3D1179_pCu_d0.700mM_t+060m_vs_NRC-1h1.sig
sDura3D1179_pCu_d0.700mM_t+180m_vs_NRC-1h1.sig
sDura3D1179_pCu_d0.700mM_t-015m_vs_NRC-1h1.sig
sDura3D1179_pCu_d1.000mM_t+015m_vs_NRC-1h1.sig
sDura3D1179_pCu_d1.000mM_t+030m_vs_NRC-1h1.sig
sDura3D1179_pCu_d1.000mM_t+060m_vs_NRC-1h1.sig
sDura3D1179_pCu_d1.000mM_t+180m_vs_NRC-1h1.sig
sDura3D1179_pCu_d1.000mM_t-015m_vs_NRC-1h1.sig
sDura3D1179_pNULL_d0.000mM_t+015m_vs_NRC-1h1.sig
sDura3D1179_pNULL_d0.000mM_t+030m_vs_NRC-1h1.sig
sDura3D1179_pNULL_d0.000mM_t+060m_vs_NRC-1h1.sig
sDura3D1179_pNULL_d0.000mM_t+180m_vs_NRC-1h1.sig
sDura3D1179_pNULL_d0.000mM_t-015m_vs_NRC-1h1.sig
sDura3D1179_pZn_d0.005mM_t+015m_vs_NRC-1h1.sig
sDura3D1179_pZn_d0.005mM_t+030m_vs_NRC-1h1.sig
sDura3D1179_pZn_d0.005mM_t+060m_vs_NRC-1h1.sig
sDura3D1179_pZn_d0.005mM_t+180m_vs_NRC-1h1.sig
sDura3D1179_pZn_d0.005mM_t-015m_vs_NRC-1h1.sig
sDura3D1179_pZn_d0.020mM_t+015m_vs_NRC-1h1.sig
sDura3D1179_pZn_d0.020mM_t+030m_vs_NRC-1h1.sig
sDura3D1179_pZn_d0.020mM_t+060m_vs_NRC-1h1.sig
sDura3D1179_pZn_d0.020mM_t+180m_vs_NRC-1h1.sig
sDura3D1179_pZn_d0.020mM_t-015m_vs_NRC-1h1.sig
sDura3D1179_pZn_d0.050mM_t+015m_vs_NRC-1h1.sig
sDura3D1179_pZn_d0.050mM_t+030m_vs_NRC-1h1.sig
sDura3D1179_pZn_d0.050mM_t+060m_vs_NRC-1h1.sig
sDura3D1179_pZn_d0.050mM_t+180m_vs_NRC-1h1.sig
sDura3D1179_pZn_d0.050mM_t-015m_vs_NRC-1h1.sig
sDura3_pCu_d0.100mM_t+015m_vs_NRC-1h1.sig
sDura3_pCu_d0.100mM_t+030m_vs_NRC-1h1.sig
sDura3_pCu_d0.100mM_t+060m_vs_NRC-1h1.sig
sDura3_pCu_d0.100mM_t+180m_vs_NRC-1h1.sig
sDura3_pCu_d0.100mM_t-015m_vs_NRC-1h1.sig
sDura3_pCu_d0.700mM_t+015m_vs_NRC-1h1.sig
sDura3_pCu_d0.700mM_t+030m_vs_NRC-1h1.sig
sDura3_pCu_d0.700mM_t+060m_vs_NRC-1h1.sig
sDura3_pCu_d0.700mM_t+180m_vs_NRC-1h1.sig
sDura3_pCu_d0.700mM_t-015m_vs_NRC-1h1.sig
sDura3_pCu_d1.000mM_t+015m_vs_NRC-1h1.sig
sDura3_pCu_d1.000mM_t+030m_vs_NRC-1h1.sig
sDura3_pCu_d1.000mM_t+060m_vs_NRC-1h1.sig
sDura3_pCu_d1.000mM_t+180m_vs_NRC-1h1.sig
sDura3_pCu_d1.000mM_t-015m_vs_NRC-1h1.sig
sDura3_pNULL_d0.000mM_t+015m_vs_NRC-1h1.sig
sDura3_pNULL_d0.000mM_t+030m_vs_NRC-1h1.sig
sDura3_pNULL_d0.000mM_t+060m_vs_NRC-1h1.sig
sDura3_pNULL_d0.000mM_t+180m_vs_NRC-1h1.sig
sDura3_pNULL_d0.000mM_t-015m_vs_NRC-1h1.sig
sDura3_pZn_d0.005mM_t+015m_vs_NRC-1h1.sig
sDura3_pZn_d0.005mM_t+030m_vs_NRC-1h1.sig
sDura3_pZn_d0.005mM_t+060m_vs_NRC-1h1.sig
sDura3_pZn_d0.005mM_t+180m_vs_NRC-1h1.sig
sDura3_pZn_d0.005mM_t-015m_vs_NRC-1h1.sig
sDura3_pZn_d0.020mM_t+015m_vs_NRC-1h1.sig
sDura3_pZn_d0.020mM_t+030m_vs_NRC-1h1.sig
sDura3_pZn_d0.020mM_t+060m_vs_NRC-1h1.sig
sDura3_pZn_d0.020mM_t+180m_vs_NRC-1h1.sig
sDura3_pZn_d0.020mM_t-015m_vs_NRC-1h1.sig
sDura3_pZn_d0.050mM_t+015m_vs_NRC-1h1.sig
sDura3_pZn_d0.050mM_t+030m_vs_NRC-1h1.sig
sDura3_pZn_d0.050mM_t+060m_vs_NRC-1h1.sig
sDura3_pZn_d0.050mM_t+180m_vs_NRC-1h1.sig
sDura3_pZn_d0.050mM_t-015m_vs_NRC-1h1.sig 
EOF
  @conds = cond_names.split("\n")
end


  
  def swf
    redirect_to "/gwap2_take2.html"
  end  
  
  def ie_debug
    if (params[:id].nil? || params[:id] != 'false')
      session[:ie_debug] = true
    else
      session[:ie_debug] = false
    end          
    render :text => "IE Debugging Set"
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
 
 def relate_condition_groups
   @group_names = params[:groupNames].split("~~").reject{|x|x.empty?}
   render :partial => 'relate_condition_groups'
 end
    
 def sparkline()
   exp = Experiment.find params[:id]
     columns, maxrange, minrange, h, rejected_columns = SparklineHelper.get_sparkline_info(exp.id)
#     render :text => "hi #{columns.size}"
     render(:partial => "single_sparkline", :layout => false, :locals => {
       :exp => exp, :columns => columns, :h => h, :maxrange => maxrange, :minrange => minrange
     })
 end 
 
 def espark
   render :text => bumpspark_tag([12, 34, 12, 42, 12, 23])
 end                                             
 
 def gene_search                                                         
   #exp_ids =  get_condition_id_list_from_mixed_list(params['exps']).split(",")
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
   @matches, @proteins = SearchHelper.full_search(params['search'])
   @annos = AnnotationHelper.get_annotations(@proteins)
   render(:partial => "annotations", :locals => {:annotations => @annos})
 end     
 
 def heatmap
   cond_ids = MainController.get_condition_id_list_from_mixed_list(params['exps'])
   @matches, @proteins = SearchHelper.full_search(params['search'])
   colnames, rows = ExpressionHelper.get_expr_data_for_conditions(@proteins, cond_ids)
   @heatmap = VisHelper.matrix_as_google_response(colnames,rows, "gene_name","GENE")
   render(:partial => "heatmap", :locals => {:data => @heatmap})
 end

 def table
   cond_ids = MainController.get_condition_id_list_from_mixed_list(params['exps'])
   @matches, @proteins = SearchHelper.full_search(params['search'])
   colnames, rows = ExpressionHelper.get_expr_data_for_conditions(@proteins, cond_ids)
   @table = VisHelper.matrix_as_google_response(colnames,rows, "gene_name","GENE")
   render(:partial => "table", :locals => {:data => @table})
 end       
 
 def plot
   cond_ids = MainController.get_condition_id_list_from_mixed_list(params['exps'])
   @matches, @proteins = SearchHelper.full_search(params['search'])
   colnames, rows = ExpressionHelper.get_expr_data_for_conditions(@proteins, cond_ids)
   @plot = VisHelper.matrix_as_google_response(@proteins, rows.transpose, "condition_name", "CONDITION")
   render(:partial => "plot", :locals => {:data => @plot})
 end       
 
 def network
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

 def import_experiment
   @project_id = params[:project_id]
   @timestamp = params[:timestamp]
 end 
 
 def do_import
   @exp = PipelineImporter.import_experiment(params[:project_id],params[:timestamp],session[:user])
   redirect_to :action => "edit_experiment", :experiment_id => @exp.id
   #render :action => "edit_experiment" #todo redirect to edit_experiment with experiment_id in url
 end
 
 def edit_experiment
   @exp = Experiment.find params[:experiment_id]
   @reference_samples = ReferenceSample.find :all
   @users = User.find :all
   @repls = []
   (1..10).each{|i|@repls << i}
   @repls.unshift nil
   @species = Species.find :all
   @curation_statuses = CurationStatus.find :all
   @growth_media_recipes = GrowthMediaRecipe.find :all
   @controlled_vocab_items = ControlledVocabItem.find :all
   @units = Unit.find :all, :order => 'name', :conditions => 'id > 1'
   @papers = Paper.find :all, :order => 'short_name'
   @aliases = Gene.find_by_sql "select * from genes where alias is not null and name in (select gene from knockouts)"
   @knockouts = Knockout.find :all, :conditions => "gene != 'wild type'", :order => 'gene'
   for al in @aliases                                      
     ko = @knockouts.detect{|i|i.gene == al.name}
     ko.gene_alias = al.alias
   end 
   @env_perts = 
     EnvironmentalPerturbation.find_by_sql("select distinct perturbation from environmental_perturbations  order by perturbation").map{|i|i.perturbation}
 end

 def show_all_exps  #default action  
   @all_tags = ExperimentTag.find_by_sql("select distinct tag, auto from experiment_tags order by tag")
   @manual_tags = @all_tags.find_all{|i|i.auto == false}.map{|i|i.tag}.sort.uniq
   @manual_tags.unshift("")
   @remaining_tags = @all_tags
   @exps = Experiment.find(:all, :order => 'name', :include =>[{:conditions=>:observations}])
   #@tag_categories = TagCategory.find :all, :order => 'category_name'
   @tag_categories = TagCategory.find_by_sql "select * from tag_categories where id in (select distinct tag_category_id from experiment_tags) order by category_name"
   #@exps = Experiment.find(:all)
 end
 
 def add_experiment_tag
   # todo - should show a warning, or disallow adding tag, if user tries to add tag with the same name as an auto-generated tag
   # or does that not make sense? (it would complicate displaying auto tags differently from manual tags)     

   cond_ids = MainController.get_condition_id_list_from_mixed_list(params['experiments'])
   
   
   existing_tags = ExperimentTag.find :all, :conditions => ["auto = false and tag = ?", params[:tag]]
   
   for cond_id in cond_ids
     new_tag = ExperimentTag.new(:condition_id => cond_id, :tag => params[:tag], :owner_id => session[:user].id, :alias_for => params[:tag],
       :tag_category_id => params[:tagCategory], :auto => false)
     unless existing_tags.detect{|i|i.condition_id == new_tag.condition_id and i.tag = new_tag.tag}
       new_tag.save
     end
   end
   @all_tags = ExperimentTag.find_by_sql("select distinct tag, auto from experiment_tags order by tag")
   @tag_categories = TagCategory.find :all, :order => 'category_name'
   @manual_tags = @all_tags.find_all{|i|i.auto == false}.map{|i|i.tag}.sort.uniq
   @manual_tags.unshift("")

   
   #render :partial => "experiment_tags", :locals => {:tags => @all_tags, :categories => @tag_categories, :cumulative => false, 
   #     :selected_tags => @selected_tags
   
   #ExperimentTag.new(:experiment_id => params[:id], :tag => params['tag'], :auto => false, :is_alias => false, :alias_for => params['tag']).save
   #experiment_tags = ExperimentTag.find_all_by_experiment_id(params[:id], :all, :order => 'tag')
   render :partial => "experiment_tags", :locals => {:tags => @all_tags, :categories => @tag_categories, :cumulative => false,
     :manual_tags => @manual_tags}
 end   
 
 def get_gwap1_ids
   exp_ids = params[:exp_ids].gsub(/,$/, "")
   gwap1_ids = Experiment.find_by_sql(["select gwap1_id from experiments where id in (?)",exp_ids.split(",")]).map{|i|i.gwap1_id}
   ret = "var gwap_url = 'http://gaggle.systemsbiology.net/GWAP/dmv/dynamic.jnlp?host=gaggle.systemsbiology.net&port=&exps=#{gwap1_ids.join(",")}';"
   render :text => ret
 end
 
 def get_dmv_url
   exp_ids = params[:exp_ids].gsub(/,$/, "")
   cond_ids = Condition.find_by_sql(["select id from conditions where experiment_id in (?)", exp_ids]).map{|i|i.id}
   url =  "http://#{request.host}:#{request.port}/data/emiml.xml?cond_ids=#{cond_ids.join(",")}"
   ret = "var gwap_url = '#{url}';"
   render :text => ret
 end
 
 def experiment_detail
   @exp = Experiment.find(params[:id], :include =>[{:conditions=>:observations}]) 
   #if (@exp.has_knockouts)
   unless (@exp.knockouts.empty?)
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
   
   @manual_tags = ExperimentTag.find :all, :conditions => ['auto = false and experiment_id = ?',@exp.id ], :order => 'tag'
   @auto_tags = ExperimentTag.find :all, :conditions => ['auto = true and experiment_id = ?',@exp.id ], :order => 'tag_category_id, tag'
   @auto_tag_categories = {}
   @auto_tags.each {|i| @auto_tag_categories[i.tag_category.category_name] = []}
   @auto_tags.each do |tag|
#     @auto_tag_categories[tag.category.category_name] << tag
   end
 end
 
 def inclusive_search
   raw_tags = params['tags'].gsub(/\#\#$/,"")
   tags = raw_tags.split("##") 
   negate = " " 
   negate = " not " if params[:negate] == 'true'
   cond_exps = Condition.find_by_sql("select id, experiment_id from conditions")
   cond_exp_map = {}
   cond_exps.each{|i|cond_exp_map[i.id] = i.experiment_id}
   condition_list_sql = <<"EOF"
   select distinct condition_id from experiment_tags where tag #{negate} in (?)
EOF
   condition_list = Experiment.find_by_sql([condition_list_sql,tags]).map{|i|i.condition_id.to_i}
   chosen_conditions = {}
   condition_list.each{|i|chosen_conditions[i]=1}
   exp_list = []
   condition_list.each{|i|exp_list << cond_exp_map[i]}
   

   
   sql = <<"EOF"
   select * from experiments where id in (?) order by created_at
EOF
   @exps = Experiment.find_by_sql([sql,exp_list])  
   @negate = ""
   @negate = "(Negated)" if params[:negate] == 'true'
   @sparklines = []                   
   exp_cond_nums = {}
   for exp in @exps
     columns, maxrange, minrange, h, rejected_columns = SparklineHelper.get_sparkline_info(exp.id)
     sparkline = render_to_string(:partial => "sparkline", :locals => {
       :exp => exp, :columns => columns, :h => h, :maxrange => maxrange, :minrange => minrange
     })
     @sparklines << sparkline
     #which_conditions(exp, chosen_conditions)
     #exp_cond_nums[exp.id.to_s] = exp.conditions.size
     exp_cond_nums[exp.id.to_s] = which_conditions(exp, chosen_conditions)
     
     
   end
   
   render :partial => "inclusive_search", :locals => {:exps => @exps, :sparklines => @sparklines, :rejected_columns => rejected_columns,
     :exp_cond_nums => exp_cond_nums.to_json, :tags => tags}
 end
          
 def which_conditions(exp, chosen_conditions)  
   exp.num_conditions_included = 0
   includes_all = true
   for cond in exp.conditions
     unless chosen_conditions.has_key? cond.id
       includes_all = false
       cond.included = false
     else
       exp.num_conditions_included += 1
       cond.included = true  
     end
   end
   return exp.num_conditions_included
 end
 
 def old_tag_exps     
   response.content_type = "text/javascript"
   render :update do |page|
     page.replace_html "test", "<h1>yowza!</h1>"
   end
 end
 
 def test_matrix
   headers['Content-type'] = 'text/plain'
   render :action => 'test_matrix', :layout => false
 end   
 
 def another_test_matrix
   test_matrix
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
        
  def self.get_condition_id_list_from_mixed_list(mixed_list)
    items = mixed_list.split(",")
    ret = []
    for item in items
      if (item =~ /^e/)
        exp_id = item.gsub(/^e/,"")
        cond_ids = Condition.find_by_sql(["select id from conditions where experiment_id = ?",exp_id]).map{|i|i.id}
        ret += cond_ids
      else
        ret << item.to_i
      end
    end
    ret
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
  
  def condition_chooser
    render :partial => "condition_chooser", :locals => {:exp => Experiment.find(params[:exp_id])}
  end
  

  def self.norm(a)
    ret = []
    for item in a
      ret << normalize(item, a.min, a.max)
    end
    ret
  end
  
  
end
