class Util
  
  def self.get_cond_map
    cond_groupings = Legacy.find_by_sql("select * from condition_groupings")
    condmap = {}
    for item in cond_groupings
      condmap[item.condition_id.to_i] = item.condition_group_id.to_i
    end
    condmap
  end
end