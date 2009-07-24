class DataOutputHelper
  
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