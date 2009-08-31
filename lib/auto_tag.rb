class AutoTag
  
  require 'pp'
  
  #todo - real synonyms         
  
  
  @synonyms = {'VNG0149G' => ['zntA'], "VNG6373G" => ["phr1"], "VNG1673G" => ["pyrF","ura3"], "VNG0700G" => ["yvgX"], "CuSO4.5H2O" => ["copper sulfate"], "ZnSO4.7H2O" => ["zinc sulfate"], "VNG2579G" => ["idr1"], "VNG0835G" => ["idr2"], "VNG0536G" => ["sirR"]}
  raw_genes_with_aliases = Gene.find_by_sql("select name, alias from genes where alias is not null")
  raw_genes_with_aliases.each do |record|
    #pp record
    ary = [record.alias]
    @synonyms[record.name] = ary unless @synonyms.has_key?(record.name)
  end
  
#  exit if true
  
  @categories = {}
  
  def self.add_tag(exp, tag, type)
    e = ExperimentTag.new(:experiment_id => exp.id, :tag => tag, :auto => true, :is_alias => false, :alias_for => tag,
    :tag_category_id => @categories[type])
##    pp e                
    e.save
    if @synonyms.has_key?(tag)
      for item in @synonyms[tag]
        e = ExperimentTag.new(:experiment_id => exp.id, :tag => item, :auto => true, :is_alias => true, :alias_for => tag,
          :tag_category_id => @categories[type])
##        pp e                                                                        
        e.save
      end
    end
  end
  
  exps = Experiment.find :all
  cats = TagCategory.find :all
  for cat in cats
    @categories[cat.category_name] = cat.id
  end

  ExperimentTag.transaction do
    begin              
      Experiment.connection.execute("delete from experiment_tags where auto = true")

      for exp in exps    
        add_tag(exp, "control", "Experiment Type") if exp.is_control
        add_tag(exp, "not control", "Experiment Type") unless exp.is_control    
        ts = (exp.is_time_series) ? "time series" : "steady state"
        add_tag(exp, ts, "Experiment Type")
        add_tag(exp, 'knockout', "Genetic") if exp.has_knockouts
        add_tag(exp, 'overexpression', "Genetic") if exp.has_overexpression
        add_tag(exp, exp.reference_sample.name, "Other") unless exp.reference_sample.nil?
        add_tag(exp, 'all genetic', "Genetic") if exp.has_knockouts or exp.has_overexpression
        add_tag(exp, 'all environmental', "Environmental") if exp.has_environmental
        for gp in exp.knockouts
          add_tag(exp, gp.gene, "Genetic")
        end
        for ep in exp.environmental_perturbations
          add_tag(exp, ep.perturbation, "Environmental")
        end
        unless exp.description.nil? 
          if exp.description.downcase =~ /chj lab/
            add_tag(exp, "CHJ Lab", "Experiment Type")
          elsif exp.description.downcase =~ /jdr lab/
            add_tag(exp, "JDR Lab", "Experiment Type")
          else
            add_tag(exp, "Baliga Lab", "Experiment Type")
          end
        end
        
        unless exp.owner_id.nil?
          owner = User.find exp.owner_id
          username = owner.email.split("@").first
          add_tag(exp, username, "Owner")
        else
          add_tag(exp, "Unknown Owner", "Owner")
        end
                                  
        add_tag(exp, exp.species.name, "Other")
        add_tag(exp, exp.species.alternate_name, "Other")
        #add_tag(exp, 'published') if ((!exp.papers.nil?) and exp.papers.size > 0)     
        unless (exp.papers.nil?)
          for paper in exp.papers
            add_tag(exp, paper.short_name, "Papers")
          end
        end
        add_tag(exp, "Not Published", "Papers") if exp.papers.empty?
        add_tag(exp, exp.growth_media_recipe.name, "Other")
        
      end

      # for FY
      eh = {}
      files =  ["ratios_154cond.txt", "ratios_161cond2.txt"]
      files.each_with_index do |file, i| 
        
        f = File.open("#{RAILS_ROOT}/data/#{file}")
        cnames = f.readlines.first.chomp.split("\t")
        cnames.shift
        #pp cnames
        for cname in cnames
          cond = Condition.find_by_name(cname)
          eh[[cond.experiment,i]] = 1
        end
        
      end
      
      eh.each_key do |k|    
        #puts "ok"
        tag = (k.last == 0) ? "FYL_GTFs:Lrps:154conditions:200908" : "FYL_GTFs:Lrps:161 conditions:200908"
        add_tag(k.first, tag, "Other")
      end
      
      
      
    rescue Exception => ex
      puts ex.message
      puts ex.backtrace
    end
  end

  
  
  
  
  
end