class DataOutputHelper < ApplicationController
  require 'rexml/document'
  include REXML
  
  require 'pp'
  
  def self.as_matrix(data) # todo - improve performance
    out = "GENE\t"
    cond_list = []
    cond_hash = {}
    first_gene = data.first.gene_name
    count = 0
    data.each do |d|
      cond_list << d.condition_name unless cond_hash.has_key?(d.condition_name)
      cond_hash[d.condition_name] = 1
      count += 1 if d.gene_name == first_gene  # this won't work for location-based data
    end
    out += cond_list.join("\t")
    #out += "\n"
    rows_per_sample = data.size / count
    
    puts "count = #{count}" 
    puts "rows_per_sample = #{rows_per_sample}"
   
    #data = data[0..11]#remove me
    
    data.inject("_nothing_") do |memo, i|
      unless i.gene_name == memo
        out.gsub!(/\t$/,"") # use substr here instead to improve performance?
        out += "\n"
        out += i.gene_name
        out += "\t" 
      end
      out += "#{i.value}"
      out += "\t"
      i.gene_name
    end
    out.gsub!(/\t$/,"")
    out += "\n"
    out
#    "done"
  end  
  
  
  
  def self.get_emiml(url, path, cond_list)
    doc = Element.new("experiment")
    doc.attributes["date"] = Time.now.strftime("%Y-%m-%d")
    doc.attributes['name'] = 'gwap2 search results'
    species = Element.new("predicate")
    species.attributes["category"] = "species"
    species.attributes["value"] = "Halobacterium sp. NRC-1" # todo unhardcode
    doc.add(species)
              
    
    perturbation = Element.new("predicate")
    perturbation.attributes["category"] = "perturbation"
    perturbation.attributes["value"] = path
    doc.add(perturbation)
    
    ratio = Element.new('dataset')
    ratio.attributes['status'] = 'primary'
    ratio.attributes['type'] = 'log10 ratios'
    ratio_url = "URL_SUB?cond_ids=#{cond_list.join(",")}&data_type=ratios" 
    ratio_uri = Element.new("uri")
    ratio_uri.root.text = ratio_url
                   
    ratio.add(ratio_uri)
    
    doc.add(ratio)
    
    lambda = Element.new('dataset')
    lambda.attributes['status'] = 'derived'
    lambda.attributes['type'] = 'lambdas'
    lambda_url = "URL_SUB?cond_ids=#{cond_list.join(",")}&data_type=lambda" 
    lambda_uri = Element.new("uri")
    lambda_uri.root.text = lambda_url
    lambda.add(lambda_uri)
    
    doc.add(lambda)


    for cond_id in cond_list
      cond = Condition.find cond_id
      cond_xml = Element.new("condition")
      cond_xml.attributes["alias"] = cond.name
      for ob in cond.observations
        ob_xml = Element.new("variable")
        ob_xml.attributes['name'] = ob.name
        ob_xml.attributes['value'] = ob.string_value
        ob_xml.attributes['units'] = ob.unit_name unless ob.units_id.nil?
        cond_xml.add(ob_xml)
      end
      doc.add(cond_xml)
    end

    
    fmt =  REXML::Formatters::Pretty.new(2)
    fmt.compact = true 
    strang = ""             
    #return url if true
    fmt.write(doc, strang)
    strang
    strang.gsub("URL_SUB",url)
    #puts doc
  end
  
  def self.get_data(cond_ids,data_type_str)
    data_types = DataType.find :all
    
    data_type = data_types.detect{|i|i.name.downcase =~ /#{data_type_str}/}.id


    query = <<"EOF" # for now this query hardcodes some of the options above
      select f.*, g.name as gene_name, c.name as condition_name from features f, genes g, conditions c
      where g.id = f.gene_id                                           
      and c.id = f.condition_id
      and f.condition_id in (?)
      and f.data_type = ?
      order by g.name, f.condition_id
EOF
    #unsorted_data = Feature.find_by_sql([query,cond_ids,data_type])
    Feature.find_by_sql([query,cond_ids,data_type])
  end
end