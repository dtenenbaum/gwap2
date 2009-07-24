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
    
    data = DataOutputHelper.get_data(cond_ids,data_type)

    render :text => DataOutputHelper.as_matrix(data)
    
    
  end
  
  def get_emiml
  end
  
end
