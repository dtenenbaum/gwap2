class AutoTag
  
  require 'pp'
  
  #todo - real synonyms
  @synonyms = {'VNG0149G' => ['zntA'], "VNG0700G" => ["yvgX"], "CuSO4.5H2O" => ["copper","Cu","CuSO4"], "ZnSO4.7H2O" => ["zinc", "Zn", "ZnSO4"]}
  
  def self.add_tag(exp, tag)
    e = ExperimentTag.new(:experiment_id => exp.id, :tag => tag, :auto => true, :is_alias => false, :alias_for => tag)
    pp e                
    e.save
    if @synonyms.has_key?(tag)
      for item in @synonyms[tag]
        e = ExperimentTag.new(:experiment_id => exp.id, :tag => item, :auto => true, :is_alias => true, :alias_for => tag)
        pp e                                                                        
        e.save
      end
    end
  end
  
  exps = Experiment.find :all

  Experiment.connection.execute("delete from experiment_tags where auto = true")
  
  for exp in exps
    add_tag(exp, 'time series') if exp.is_time_series
    add_tag(exp, 'knockout') if exp.has_knockouts
    add_tag(exp, 'overexpression') if exp.has_overexpression
    add_tag(exp, exp.reference_sample.name) unless exp.reference_sample.nil?
    add_tag(exp, 'genetic') if exp.has_knockouts or exp.has_overexpression
    add_tag(exp, 'environmental') if exp.has_environmental
    for gp in exp.knockouts
      add_tag(exp, gp.gene)
    end
    for ep in exp.environmental_perturbations
      add_tag(exp, ep.perturbation)
    end                           
    add_tag(exp, exp.species.name)
    add_tag(exp, exp.species.alternate_name)
    add_tag(exp, 'published') if ((!exp.papers.nil?) and exp.papers.size > 0)
  end
  
  
  
  
  
end