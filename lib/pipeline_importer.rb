class PipelineImporter
  require 'pp'
  PIPELINE_DIR= '/Volumes/Arrays'
  
  
  def self.get_oligo_map
    oligo_files = `ls -1 #{PIPELINE_DIR}/Slide_Templates/halo_oligo*.map`

    tmp = []
    oligo_files.each do |i|
      num = i.split("_").last.gsub(/\.map$/,"")
      items = num.split("-")
      tmp << [items.first.to_i, items.last.to_i, i]
    end

    sorted = tmp.sort do |a,b|
      (a.first + a[1]) <=> (b.first + b[1])
    end                                           

    newest = sorted.last.last.chomp


    map = {}

    f = File.open(newest)
    first = true
    while (line = f.gets)     
      if first
        first = false
        next
      end
      segs = line.split("\t")
      ref = segs[4]
      vng = segs[10]
      map[ref] = vng
    end
    map
  end    
  
  def self.get_slide_numbers(project_id, timestamp) 
    ft_files = `ls -1 #{PIPELINE_DIR}/Pipeline/output/project_id/#{project_id}/#{timestamp}/*.ft`.split("\n")
    map = {}
    for file in ft_files
      name = file.split("/").last().gsub(/\.ft$/,".sig")
      f = File.open(file)
      while (line = f.gets)         
        num = line.split(".").first
        forward_slide_number = num  if (line =~ /\tf\t1/)
        reverse_slide_number = num  if (line =~ /\tr\t2/)
      end
      map[name] = []
      map[name] << forward_slide_number
      map[name] << reverse_slide_number
    end
    map
  end
  
  def self.create_conditions(headers, exp, slidenums)
    saved_conds = []
    conds = headers.split("\t")
    conds.pop
    conds.shift
    conds.shift
    conds = conds[0..(conds.size/2)-1]
    conds.each_with_index do |cond, i|
      c = Condition.new(:experiment_id => exp.id, :name => cond, :sequence => i+1,
        :forward_slide_number => slidenums[cond].first, :reverse_slide_number => slidenums[cond].last)
      c.save        
      #puts "saving condition:"
      #pp c
      saved_conds << c
    end
    saved_conds
  end

  def self.add_feature(value, index, conditions, type, gene_id)
    condition = conditions[index]
    datatype = 1 if (type == "ratios")
    datatype = 2 if (type == 'lambdas')
    f = Feature.new(:value => value, :condition_id => condition.id, :gene_id => gene_id, :data_type => datatype)
    f.save
    #pp f
  end


  def self.add_features(line, conditions, oligo_map, genes)
    segs = line.split("\t")
    orig_name = segs.shift
    vng_name = oligo_map[orig_name]
    gene_id = genes.detect{|i|i.name == vng_name}.id
    #puts "mapping original name #{orig_name} to vng name #{vng_name} to gene_id #{gene_id}"
    segs.shift
    segs.pop
    mid = segs.length/2
    ratios = segs[0..(mid)-1]
    lambdas = segs[mid..segs.size]
    ratios.each_with_index {|value,i|add_feature(value,i, conditions, 'ratios', gene_id )}
    lambdas.each_with_index  {|value,i|add_feature(value,i, conditions, 'lambdas', gene_id )}
  end

  
  
  def self.import_experiment(project_id, timestamp, importer)
    begin      
      oligo_map = get_oligo_map()     
      #puts "oligo map:"
      #pp oligo_map
      genes = Gene.find :all
      Condition.transaction do
        slidenums = get_slide_numbers(project_id, timestamp)
        exp = Experiment.new(:sbeams_project_id => project_id.to_i, :sbeams_project_timestamp => timestamp,
          :platform_id => 1, :importer_id => importer.id, :species_id => 1, :curation_status_id => 1, :is_private => true, 
          :has_tracks => false)
        exp.sbeams_project_timestamp += "___TEST!!!"
        exp.save
        #puts "saving experiment:"
        #pp exp
        f = File.open("#{PIPELINE_DIR}/Pipeline/output/project_id/#{project_id}/#{timestamp}/matrix_output")
        count = -1
        while (line = f.gets)
          line.chomp! 
          next if line =~ /^NumSigGenes/
          count += 1
          next if count == 0
          conditions = create_conditions(line, exp, slidenums) if count == 1
          next if count == 1
          add_features(line, conditions, oligo_map, genes)
        end
        puts "Imported experiment #{exp.id}." 
        return exp
      end
    rescue Exception => ex
      puts ex.message
      puts ex.backtrace
    end
    
  end 
  
  def self.delete_experiment(experiment_id)  
    # todo - delete all other associations
    e = Experiment.find experiment_id
    begin
      Condition.transaction do
        for cond in e.conditions
          Feature.connection.execute("delete from features where condition_id = #{cond.id}")
          Condition.delete cond.id
        end
        Experiment.delete(experiment_id)
      end
    rescue Exception => ex
      puts ex.message
      puts ex.backtrace
    end
    
  end
  
  
end