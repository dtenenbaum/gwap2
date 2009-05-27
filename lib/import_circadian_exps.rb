class ImportCircadianExps
  require 'pp'                                            
  # WARNING THIS WILL DELETE TABLES!!!!
##  Experiment.connection.execute("truncate table experiments")
##  Experiment.connection.execute("truncate table conditions")
  @reference_samples = ReferenceSample.find :all

  
  def self.get_reference_sample(condlist)
    name = condlist.first.name.gsub(".sig", "")
    return 3 unless name =~ /NRC-1/ #specialcase
    stuff, code = name.split("NRC-1")
    refname = "NRC-1#{code}"
    ref = @reference_samples.detect{|i|i.name == refname}
    ref.id
  end                              
  
  f = File.open("#{RAILS_ROOT}/data/circadian_conds.txt")
  cond_names = []
  while line = f.gets
    line.chomp!
    next if line.empty?
    cond_names << line
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
        n = Experiment.new(:name => exp.name,
          :reference_sample_id => get_reference_sample(conds),  
          :growth_media_recipe_id => 1, #cm
          :sbeams_project_id => exp.sbeams_project_id,
          :sbeams_project_timestamp => exp.sbeams_timestamp,
          :gwap1_id => exp.id,
          :orig_filename => exp.orig_filename,
          :platform_id => 1,
          :description => exp.description,
          :date_gwap1_imported => exp.date,
          #owner id => ...  
          :has_knockouts => false,
          :has_overexpression => false,
          #:replicate => ???,
          #:biological_replicate => ???,
          :has_environmental => true,
          :species_id => 1,
          :curation_status_id => 4, # approved!!
          :is_private => :false,     
          :parent_strain_id => 1,
          :is_time_series => true,#(exp.name =~ /concentrations/) ? false : true,
          :uses_probe_numbers => false
          ) 
        first_phr = true
        if (conds.first.name =~ /phr/)
          if first_phr
            ko = Knockout.new(:gene => 'VNG6373G', :ranking => 1, :parent_id => 1)
            n.has_knockouts = true
          end
        end
        n.save
        unless (ko.nil?)
          ko.experiment_id = n.id
          ko.save        
        end
        old_to_new[exp.id] = n.id
        new_to_old[n.id] = exp.id
        for cond in conds
          c = Condition.new(:name => cond.name,
            :experiment_id => n.id,
            :sequence => (cond.orig_sequence.to_i + 20)) # so non-data conds can go first
          puts "c.experiment_id = #{c.experiment_id}"
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