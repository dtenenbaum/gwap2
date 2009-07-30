class FixStarv
  orig_exp = Experiment.find 184
  
  
  begin
    Condition.transaction do
      orig_exp.name = 'idr1_+Fe_starv'
      
      idr1_minus_fe = orig_exp.clone
      idr1_minus_fe.name = "idr1_-Fe_starv"
      
      idr2_nrc1 = orig_exp.clone
      idr2_nrc1.name = "idr2_vs_NRC-1_starv"
      
      idr2_plus_fe = orig_exp.clone
      idr2_plus_fe.name = 'idr2_+Fe_starv'
      
      idr2_minus_fe = orig_exp.clone
      idr2_minus_fe.name = 'idr2_-Fe_starv'
      
      sirr_nrc1 = orig_exp.clone
      sirr_nrc1.name = 'sirR_vs_NRC-1_starv'
      
      sirr_plus_fe = orig_exp.clone
      sirr_plus_fe.name = 'sirR_+Fe_starv'
      
      sirr_minus_fe = orig_exp.clone
      sirr_minus_fe.name = 'sirR_-Fe_starv'
      
      ura3_plus_fe = orig_exp.clone
      ura3_plus_fe.name = 'ura3_+Fe_starv'
      
      
      
    end
  rescue Exception => ex
    puts ex.message
    puts ex.backtrace
  end
  
end