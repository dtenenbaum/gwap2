class DataController < ApplicationController  
  
  def get_data #todo - make it work for location-based data as well
    #parameters:
      # data_type = ratios|lambdas|error
      # rows = all | [comma-separated list of row names]
      # exp_ids = [comma-separated list of experiment_ids] (gets data for all conditions in specified experiments)
      # cond_ids [comma-separated list of condition ids in desired order]
      # format = matrix|microformat|heatmap|plot (one of these (TODO - specify ) also works for google vis table)
      # order = gene|location - todo - add natural ordering option?
      # sort_by_condition_name = true (default false if cond_ids supplied)

    # todo - support MotionChart    
    # todo unhardcode
    
    cond_ids = []
    params[:cond_ids].split(",").each{|i|cond_ids << i.to_i}
    
    data = DataOutputHelper.get_data(cond_ids,params[:data_type])
    
    respond_to do |format|
      format.xml {render :text => DataOutputHelper.as_matrix(data)}
    end
    
    
  end
  
  def get_emiml
    url = url_for(:action => "get_data")
    headers['Content-type'] = 'text/xml'
    cond_ids = []
    params[:cond_ids].split(",").each{|i|cond_ids << i.to_i}
    path = "this:that:the other"
    render :text => DataOutputHelper.get_emiml(url, path, cond_ids)
  end   
  
  def get_jnlp
    f = File.open("#{RAILS_ROOT}/app/views/data/dmv_jnlp.xml")
    jnlp = ""
    while (line = f.gets())
      jnlp += line
    end
    cond_ids = []
    params[:cond_ids].split(",").each{|i|cond_ids << i.to_i}
    headers['Content-type'] = 'application/x-java-jnlp-file'
    url = url_for(:action => "get_emiml_outer")
    url += "?cond_ids=#{cond_ids.join(",")}"
    jnlp.gsub!(/EMIML_URL/, url)
    render :text => jnlp
  end


  def get_emiml_outer
    cond_ids = []
    params[:cond_ids].split(",").each{|i|cond_ids << i.to_i}
    url = url_for(:action => "get_emiml")
    url += "/nothing.xml?cond_ids=#{cond_ids.join(",")}"
    out = <<"EOF"
    <a href="#{url}">something</a>
EOF
    render :text => out
  end
  
end
