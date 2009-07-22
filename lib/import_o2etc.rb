class ImportO2etc
  require 'pp'                                            
  # WARNING THIS WILL DELETE TABLES!!!!
##  Experiment.connection.execute("truncate table experiments")
##  Experiment.connection.execute("truncate table conditions")
  @reference_samples = ReferenceSample.find :all     
  @kos = Knockout.find :all
  @ura3 = Knockout.find_by_gene('ura3')        
  @genes = Gene.find :all
#  @tbpa = 'VNG6037G'

  
  # is this still valid?
  def self.get_reference_sample(condlist)
    refname = ""
    ref_to_name = nil
    name = condlist.first.name.gsub(".sig", "")
    return 3 unless name =~ /NRC-1/ #specialcase    
    if name =~ /NRC-1([a-z]{0,1})_vs_NRC-1([a-z]{0,1})/
      ref_to_name = "NRC-1#{$1}"
      refname = "NRC-1#{$2}"
    else
      stuff, code = name.split("NRC-1")    
      if name =~ /NRC-1([_]?[a-z]?[1]?)$/
        code = $1.gsub("_","")
      end
      refname = "NRC-1#{code}"
    end
    ref = @reference_samples.detect{|i|i.name == refname} 
    #puts "refname = #{refname}, ref.nil? #{ref.nil?}"
    ref_to = @reference_samples.detect{|i|i.name == ref_to_name}   
    if (ref_to.nil?)
      ref_to = ReferenceSample.new
      ref_to.id = nil
    end
    #ref_to = nil if ref_to_name.nil?
    
    #puts "#{refname} #{ref_to_name} #{condlist.first.name}"
    return 9 if ref.nil?
    return ref.id, ref_to.id
  end    
  
  
  def self.get_knockout(cond)   # doesn't always return true when it should, need to clean up by hand
    props = Legacy.find_by_sql("select * from properties where condition_id = #{cond.id}" )      
    ret = props.detect{|i|i.name == 'knockout'}
    return nil if ret.nil?                
    puts "alias = #{ret.value}"
    ret.value = @genes.detect{|i|i.alias == ret.value}.name unless ret.value =~ /^VNG/
    return ret.value
    #retval = !ret.nil?
    #puts "#{cond.name} is knockout? #{retval} ret = #{ret}"# if cond.name =~ /1451/
    #return retval#!ret.nil?
  end  
  
  def self.is_time_series(cond)
    props = Legacy.find_by_sql("select * from properties where condition_id = #{cond.id}" )      
    ret = props.detect{|i|i.name == 'time'}
    retval = !ret.nil?
    #puts "#{cond.name} is ts? #{retval} ret = #{ret}"
    return retval#!ret.nil?
  end
  
  f = File.open("#{RAILS_ROOT}/data/o2_gamma_tfbtbp_envmap.txt")
  cond_names = []
  while line = f.gets
    line.chomp!
    next if line.empty?     
    segs = line.split("\t")   
    existing_cond = Condition.find_by_name(segs.first)
    cond_names << segs.first if existing_cond.nil?
  end 
  conds = Legacy.find_by_sql(["select * from conditions where name in (?)",cond_names])
  cond_ids = conds.map{|i|i.id}
  sql = "select * from condition_groups where id in (select distinct condition_group_id from condition_groupings where condition_id in (?))"
  exps = Legacy.find_by_sql([sql,cond_ids])
  old_to_new = {}
  new_to_old = {}     
  ko = nil
  #exps.each{|i|puts i.name} ; exit if true     
  
  Experiment.transaction do
    begin
      for exp in exps
        # redefining conds:
        conds = Legacy.find_by_sql(["select * from conditions where id in (select condition_id from condition_groupings where condition_group_id = ?) order by orig_sequence", exp.id])
        #puts exp.name               
        reference_sample_id, reference_to_id = get_reference_sample(conds)  
        knockout = get_knockout(conds.first)
        has_knockout = !knockout.nil?
        #puts "#{conds.first.name} A#{reference_sample_id} B#{reference_to_id}"
        n = Experiment.new(:name => exp.name,
          :reference_sample_id => reference_sample_id,  
          :reference_to => reference_to_id,
          :growth_media_recipe_id => 1, #need to correct later
          :sbeams_project_id => exp.sbeams_project_id,
          :sbeams_project_timestamp => exp.sbeams_timestamp,
          :gwap1_id => exp.id,
          :orig_filename => exp.orig_filename,
          :platform_id => 1,
          :description => exp.description,
          :date_gwap1_imported => exp.date,
          #owner id => ...  
          :has_knockouts => has_knockout,
          :has_overexpression => false,   # there is one OE/ todo fix
          #:replicate => ???,
          :biological_replicate => exp.replicate,
          :has_environmental => true,
          :species_id => 1,
          :curation_status_id => 2,
          :is_private => :false,     
          :parent_strain_id => 1,
          :is_time_series => is_time_series(conds.first),#(exp.name =~ /concentrations/) ? false : true,
          :uses_probe_numbers => false
          )   
          #pp n
          n.save
          if (n.has_knockouts)
            ko = @kos.detect{|i|i.gene == knockout}
            if ko.nil?
              ko = Knockout.new(:ranking => 2, :gene => knockout)
              puts "KO: #{ko.gene}"
              ko.save
            end
            n.knockouts << @ura3
            n.knockouts << ko
          end
        old_to_new[exp.id] = n.id
        new_to_old[n.id] = exp.id
        for cond in conds
          c = Condition.new(:name => cond.name,
            :experiment_id => n.id,
            :sequence => (cond.orig_sequence.to_i + 20)) # so non-data conds can go first
          #puts "c.experiment_id = #{c.experiment_id}"
          c.save                                                                                
          # ignoring constants for now!!!!!!!!!!
          #props = Property.find_by_sql("select * from properties where condition_id = #{cond.id} where property_type in (2,3,5,6,7)" )
          #for prop in props

          #end
        end
      end    
    rescue Exception => ex
      puts ex.message
      puts ex.backtrace
    end
  end
  
end