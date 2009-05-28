class NoDataVoodoo
  require 'pp'

   def self.format(num)
     return "0000" if num == 0
     sprintf("%05.f", num)
   end
       

    
   def self.up
     negs = [-3240, -3060, -2880, -2700, -2520, -2340, -2160, -1980, -1800, -1620, -1440, -1260, -1080, -900, -720, -540, -360, -180]#, 0]
     # bad - this is hardcoded in down
     exp_id = 147 #dark8

     #circadian_drk8_cycling_0000min_vs_NRC-1e.sig

     pos_conds = Experiment.find(exp_id).conditions  
     # luckily we start and end on 150, in other exps this may not be the case
     pos_conds.shift


        rev = pos_conds.reverse
        nms = rev.map{|i|i.name}
     #   pp nms             


        Condition.transaction do
          begin           
            rev.each_with_index do |item, i|
              c = Condition.new(:name => "circadian_drk8_cycling_#{format(negs[i])}min_vs_NRC-1e.sig", :experiment_id => exp_id,
               :sequence => i+1, :has_data => false)    
              #37 == irradiation history
              old_obs = item.observations.detect{|i|i.name_id == 37}
             puts c.name
     #        pp old_obs
             c.save
             o = Observation.new(:condition_id => c.id, :name_id => 37, :string_value => old_obs.string_value,
               :int_value => old_obs.int_value, :float_value => old_obs.float_value, :units_id => nil)
             pp o   
             o.save
            end

          rescue Exception => ex
            puts ex.message
            puts ex.backtrace
          end
        end
   end
       
   def self.down                                                        
     exp_id = 147
     conds = Condition.find :all, :conditions => "experiment_id = #{exp_id} and sequence > 20"
     for cond in conds
       obs = cond.observations
       ob = obs.detect{|i|i.name_id == 37}
       Observation.delete(ob)
     end
   end
   #up
   #down
   
   
      
end