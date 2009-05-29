class NetworkHelper                  
  require 'pp'

  def self.get_unfiltered_net(gene_names)
    species_id = 1
    MDV.find_by_sql(["select * from interactions where species_id = ? and protein1 in (?) and protein2 in (?)", species_id, gene_names, gene_names]) 
  end
    



  def self.get_network(gene_names)
    unfiltered_net = get_unfiltered_net(gene_names)
    net_without_orphans = filter_network(unfiltered_net)
    mix_in_orphans(net_without_orphans, gene_names)
  end
  
  
  def self.filter_network(input)     
    puts
             
    net_hash = {}
    
    #this is lossy
    for item in input
      next if item.protein2.nil? # how come orphans still show up? hmm....
      key = [item.protein1,item.protein2]   
                    
      #item.sources = {} unless net_hash.has_key?(key)
      #puts "INTERACTION TYPE = #{item.interaction_type_id}"
      
      #todo fix
      if item.interaction_type_id.to_i == 1
        source = 'STRING'
      elsif item.interaction_type_id.to_i == 2
        source = 'CoIP'
      elsif item.interaction_type_id.to_i == 3
        source = 'EGRIN'
      else
        puts "WTF, source is nil!! interaction = "
        pp item
        source = nil
      end
      
      net_hash[key] = {} unless net_hash.has_key?(key)
      net_hash[key][source] = ''
    end
          
    results = []
    net_hash.each_pair do |k,v|
      i = Interaction.new(:protein1 => k.first, :protein2 => k.last, :sources => v)  
      results << i
    end 
    return nil if results.empty?
    return nil if (results.size == 1 and results.first.protein2.nil?)
    results
  end        
  
  def self.mix_in_orphans(net, genelist)
    #genelist.each_index{|i|genelist[i].gsub!("'","")}   
    nodes_with_edges = {}
    if net.nil?
      net = []
    else
      for item in net
        nodes_with_edges[item.protein1] = ''
        nodes_with_edges[item.protein2] = ''
      end
    end                                
    for item in genelist
      clean = item.gsub("'","")
      unless nodes_with_edges.has_key?(clean)
        i = Interaction.new(:protein1 => clean)
        net << i
      end
    end
    return nil if net.size == 1 and net.first.protein2.nil?
    net
  end
  
end