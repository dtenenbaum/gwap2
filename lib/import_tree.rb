class ImportTree 
  require 'rubygems'
  require 'json' 
  require 'pp'           
  
  # this is from gwap2 take 1 and needs to be updated
  # this can be greatly simplified. but we need experiment ids first
  
  begin
    NavTreeItem.transaction do
      NavTreeItem.connection.execute("truncate table nav_tree_items")  
      cond_groupings = Legacy.find_by_sql("select * from condition_groupings")
      condmap = {}
      for item in cond_groupings
        condmap[item.condition_id] = item.condition_group_id
      end
      exp_ids = Legacy.find_by_sql("select id from condition_groups")
      props = Legacy.find_by_sql("select distinct condition_id, value from properties where property_type = 4") 
      obs = Legacy.find_by_sql("select distinct name, value, condition_id from properties where property_type = 2")
      obmap = Hash.new{|h,k| h[k] = Array.new}
      for ob in obs
        obmap[ob.condition_id] << {:name => ob.name, :value => ob.value}
      end                               
      
      list = []
      for prop in props
        for item in obmap[prop.condition_id]
          treepath = prop.value + ":" + item[:name] + ":" + item[:value]
          exp_id = condmap[prop.condition_id]  
          h = {:experiment_id => exp_id, :treepath => treepath}
          list << h unless list.include? h
          #puts h
        end
      end
      
      #exit if true
      
      list.each do |prop|
        puts prop[:treepath]# if prop[:treepath] =~ /:ark/
        #puts "#{prop[:treepath]}, #{prop[:experiment_id]} " if prop[:treepath] =~ /^glucose/
        segs = prop[:treepath].split(":")
        parent = 0
        segs.each_with_index do |seg,i|                        
          #puts seg
          existing_seg = NavTreeItem.find_by_name_and_level_and_parent_id(seg, i, parent) 
          if (existing_seg.nil?)                      
 #           puts "saving #{seg} #{i}" if prop[:treepath] =~ /:ark/
            n = NavTreeItem.new(:name => seg, :parent_id => parent, :level => i) 
            n.experiment_id = prop[:experiment_id] if (i == (segs.size() -1))
            n.save                     
            existing_seg = n
            parent = n.id
          else
 #           puts "not saving #{seg} #{i} #{existing_seg.id}" if prop[:treepath] =~ /:ark/
            parent = existing_seg.id
          end
          ##next if true                                                          
          
          if (i == (segs.size() -1))
            #n[:experiment_id] = prop[:experiment_id]
            #n.save                                              
            #legacy_id = condmap[prop.condition_id]
            #puts "parent = #{parent}, legacy_id = #{legacy_id}"
            #existing_leaf = LeafItem.find_by_sql("select * from leaf_items where tree_parent_id = #{parent} and legacy_id = #{legacy_id}")
            #if (existing_leaf.size() == 0)    
            #  puts "adding leaf record"
            #  l = LeafItem.new(:tree_parent_id => parent, :legacy_id => legacy_id)
            #  l.save
            #else
            #  puts "THERE IS AN EXISTING RECORD!"
            #end
          end
        end
      end
    end
  rescue Exception => ex
    puts "Exception!"
    puts ex.message
    puts ex.backtrace
  end 
  
end