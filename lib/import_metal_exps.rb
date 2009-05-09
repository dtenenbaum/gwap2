class ImportMetalExps
  require 'pp'                                            
  # WARNING THIS WILL DELETE TABLES!!!!
  Experiment.connection.execute("truncate table experiments")
  Experiment.connection.execute("truncate table conditions")
  

  f = File.open("/Users/dtenenbaum/dl/metals_envmap.txt")
  cond_names = []
  first = true
  while line = f.gets
    line.chomp!
    next if line.empty?
    if (first)
      first = false
      next
    end
    segs = line.split("\t")
    cond_names << segs.first
  end 
  conds = Legacy.find_by_sql(["select * from conditions where name in (?)",cond_names])
  cond_ids = conds.map{|i|i.id}
  sql = "select * from condition_groups where id in (select distinct condition_group_id from condition_groupings where condition_id in (?))"
  exps = Legacy.find_by_sql([sql,cond_ids])
  old_to_new = {}
  new_to_old = {}
  #exps.each{|i|puts i.name} ; exit if true
  for exp in exps
    #puts exp.name
    n = Experiment.new(:name => exp.name,
      ##:reference_sample_id => 
      :sbeams_project_id => exp.sbeams_project_id,
      :sbeams_project_timestamp => exp.sbeams_timestamp,
      :gwap1_id => exp.id,
      :orig_filename => exp.orig_filename,
      :platform_id => 1,
      :description => exp.description,
      :date_gwap1_imported => exp.date,
      #owner id => ...
      #:has_knockouts => false,
      #:has_overexpression => ???,
      #:replicate => ???,
      #:biological_replicate => ???,
      :species_id => 1,
      #:parent_strain_id => ?????,
      :curation_status_id => 4, # approved!!
      :is_private => :false,
      :is_time_series => (exp.name =~ /concentrations/) ? false : true,
      :uses_probe_numbers => false
      )                           
      n.save
      old_to_new[exp.id] = n.id
      new_to_old[n.id] = exp.id
      # redefining conds:
      conds = Legacy.find_by_sql(["select * from conditions where id in (select condition_id from condition_groupings where condition_group_id = ?) order by orig_sequence", exp.id])
      for cond in conds
        c = Condition.new(:name => cond.name,
          :experiment_id => n.id,
          :sequence => cond.orig_sequence)
        c.save                                                                                
        # ignoring constants for now!!!!!!!!!!
        #props = Property.find_by_sql("select * from properties where condition_id = #{cond.id} where property_type in (2,3,5,6,7)" )
        #for prop in props
          
        #end
      end
  end   
  
end