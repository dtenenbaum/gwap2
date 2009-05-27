class ReimportMetalExps

#  Experiment.connection.execute("truncate table experiments")        
#  Experiment.connection.execute("truncate table conditions")
   f = File.open("#{RAILS_ROOT}/data/missing_metal_conds.txt")
   condnames = []
   while (line = f.gets)
     line.chomp!
     next if line.empty?
     condnames << line
   end

   old_cond_ids = Legacy.find_by_sql(["select id from conditions where name in (?)",condnames]).map{|i|i.id}
   old_exps = Legacy.find_by_sql(["select * from condition_groups where id in (select condition_group_id from condition_groupings where condition_id in (?))",old_cond_ids])
   
   lusers = Legacy.find_by_sql("select * from users")
   users = User.find :all
   
   Experiment.transaction do
     begin
       for old_exp in old_exps
         new_exp = Experiment.new()
         new_exp.name = old_exp.name
         puts old_exp.name
         #todo reference sample
         #todo reference to
         new_exp.sbeams_project_id = old_exp.sbeams_project_id

         #this isn't working:
         new_exp.sbeams_project_timestamp = old_exp.sbeams_timestamp

         new_exp.gwap1_id = old_exp.id
         new_exp.orig_filename = old_exp.orig_filename
         #todo some experiments are ChIP-chip - any other platforms?
         new_exp.platform_id = 1
         new_exp.description = old_exp.description
         # lab notebook number
         # lab notebook page
         # date_performed
         new_exp.date_gwap1_imported = old_exp.date

         # this isn't working:
         luser = lusers.detect{|d| d.id == old_exp.owner_id}
         unless luser.nil?
           user = users.detect{|d| d.email == luser.email}
           new_exp.owner_id  = user.id
           new_exp.importer_id = user.id  #--for now, set to the same as owner_id
         end


         #new_exp.has_knockouts
         #new_exp.has_overexpression
         #new_exp.has_environmental

         new_exp.biological_replicate = old_exp.replicate

         #newexp.biological_replicate
         #new_exp.conditions_on_x_axis will default to true which should be fine
         new_exp.species_id = 1 # halo

         #todo parent_strain_id - might need a new table

         new_exp.curation_status_id = 6 # legacy
         new_exp.is_private = old_exp.is_private
         #new_exp.is_time_series

         # todo are created_at and updated_at useful in this context?

         new_exp.save
       end
     rescue Exception => ex
       puts ex.message
       puts ex.backtrace
     end
   end
   
   
end