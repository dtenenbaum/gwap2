module MainHelper 
  
  def cog_links(cog_numbers)
    #http://www.ncbi.nlm.nih.gov/COG/old/palox.cgi?txt=<%= anno.cog.gsub(/[A-Z]+$/,"") %>"><%=anno.cog %>\n
    #target="_blank" title="COG Protein Annotation" 
    cogs = cog_numbers.split(", ")
    cogs.each_with_index{|c,i|cogs[i].gsub!(/[A-Z]+$/,"")}
    items = []
    for cog in cogs
      items << "<a target='_blank' title='COG Protein Annotation' href='http://www.ncbi.nlm.nih.gov/COG/old/palox.cgi?txt=#{cog}'>#{cog}</a>"
    end
    items.join(", ")
  end
  

  def network_as_google_response_helper(net, directed=false)     

    item_id = 0

    table = {}

    cols = [{'label' => 'interactor1', 'type' => 'string'},
      {'label' => 'interactor2', 'type' => 'string'},
      {'label' => 'sources', 'type' => 'string'}]

    table['cols'] = cols   

    rows = []
    for item in net # a row
      row = {}
      cells = []               
      cells.push({'v' => item_id, 'f' => item.protein1})
      item_id += 1
      cells.push({'v' => item_id, 'f' => item.protein2}) unless item.protein2.nil?
      item_id += 1
      if (!item.sources.nil? and !item.protein2.nil?)
        keys = item.sources.keys.reject{|i|i.nil? or i.strip.empty?} # don't really know what's up here
        cells.push({'v' => keys.join(", ")}) unless keys.empty?
        
        item_id += 1
      end
      
      bla = {'c' => cells}
      rows.push bla #{'c' => cells}
    end              

    table['rows'] = rows

    table.to_json
  end
  
  def logged_in
    !session[:user].nil?
  end
  
  def email
    session[:user].email
  end
  
  def locus_annotations(annotations)
    locus = []
    annotations.each do |anno| 
      if anno.locus.nil?
        locus << anno.locus_tag
      else
        locus << anno.locus
      end
    end
    locus
  end
  
  def show_gaggle_network_item(item)
    if item.sources.nil?
      return "<tr><td>#{item.protein1}</td></tr>\n"
    end
    s = ""
    for source in item.sources
      s += "<tr><td>#{item.protein1}</td><td>#{source}</td><td>#{item.protein2}</td></tr>\n"
    end
    s
  end
  
end
