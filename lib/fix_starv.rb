class FixStarv
  orig_exp = Experiment.find 184
      
  kos = Knockout.find :all  
  ura3 = Knockout.find_by_gene 'ura3'
  idr1 = Knockout.find_by_gene 'VNG2579G'
  idr2 = Knockout.find_by_gene 'VNG0835G'
  sirr = Knockout.find_by_gene 'VNG0536G'    
  
                   
  def self.fix(exp, name, ko, conds, is_control, perturbation) # also pass in control and environmental, paper
    ura3 = Knockout.find_by_gene 'ura3'
    paper = Paper.find_by_short_name("Schmid, 2009")
    exp.name = name 
    exp.save
    exp.has_knockouts = true
    exp.knockouts = []
    exp.knockouts << ura3
    exp.knockouts << ko unless ko.nil?
    exp.save
    return if conds.nil?              
    exp.papers << paper
    exp.is_control = is_control
    EnvironmentalPerturbation.new(:experiment_id => exp.id, :perturbation => perturbation).save unless perturbation.nil?
    exp.save
    
    conditions = Condition.find_by_sql(["select * from conditions where name in (?)",conds])
    for cond in conditions
      cond.experiment_id = exp.id
      cond.save
    end
  end
  
  
  begin
    Condition.transaction do
      fix(orig_exp, 'idr1_+Fe_starv', idr1, nil, false, 'FeSO4.7H2O')
      
      idr1_minus_fe = orig_exp.clone
      fix(idr1_minus_fe, "idr1_-Fe_starv", idr1, ['idr1_40min_-Fe_vs_NRC1-h1.sig','idr1_60_min_-Fe_vs_NRC1-h1.sig'],
        true, nil)
      
      idr2_nrc1 = orig_exp.clone
      fix(idr2_nrc1, "idr2_vs_NRC-1_starv", idr2, ['idr2_0min_vs_NRC1-h1.sig'], true, nil)
      
      idr2_plus_fe = orig_exp.clone
      fix(idr2_plus_fe, 'idr2_+Fe_starv', idr2, ['idr2_20min_+Fe_vs_NRC1-h1.sig','idr2_40min_+Fe_vs_NRC1-h1.sig','idr2_60min_+Fe_vs_NRC1-h1.sig'],
        false, 'FeSO4.7H2O')
      
      idr2_minus_fe = orig_exp.clone
      fix(idr2_minus_fe,'idr2_-Fe_starv', idr2, ['idr2_20min_-Fe_vs_NRC1-h1.sig','idr2_40min_-Fe_vs_NRC1-h1.sig','idr2_60min_-Fe_vs_NRC1-h1.sig'],
        true, nil)
      
      sirr_nrc1 = orig_exp.clone
      fix(sirr_nrc1, 'sirR_vs_NRC-1_starv', sirr, ['sirR_0min_vs_NRC1_h1.sig'], true, nil)
      
      sirr_plus_fe = orig_exp.clone
      fix(sirr_plus_fe, 'sirR_+Fe_starv', sirr, ['sirR_20min_+Fe_vs_NRC1_h1.sig','sirR_40min_+Fe_vs_NRC1_h1.sig','sirR_60min_+Fe_vs_NRC1_h1.sig'],
        false, 'FeSO4.7H2O')
      
      sirr_minus_fe = orig_exp.clone
      fix(sirr_minus_fe, 'sirR_-Fe_starv', sirr, ['sirR_20min_-Fe_vs_NRC1_h1.sig','sirR_40min_-Fe_vs_NRC1_h1.sig','sirR_60min_-Fe_vs_NRC1_h1.sig'],
        true, nil)
      
      ura3_plus_fe = orig_exp.clone
      fix(ura3_plus_fe, 'ura3_+Fe_starv', nil, ['ura3_40min_+Fe_vs_NRC1-h1.sig'], true, 'FeSO4.7H2O')
   
      #raise "bortzed out" if true
      
    end
  rescue Exception => ex
    puts ex.message
    puts ex.backtrace
  end
  
end