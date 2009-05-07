class CreateProbeMap    
  p = Platform.new(:name => 'Baliga Lab Spotted Array', :description => "Standard spotted array design")
  p.save
  
  f = File.open("/local/dl/halo_gene_and_probe_coordinates.tsv")
  first = true
  while (line = f.gets) do
     if first
       first = false
       next
     end
     line.chomp!
     gene, gene_name, molecule, start, _end, strand, probe_start, probe_end = line.split("\t")
     g = GeneToPositionMap.new(:platform_id => p.id,
      :gene => gene, :molecule => molecule, :start => start, :end => _end, :strand => strand, :probe_start => probe_start,
      :probe_end => probe_end, :gene_name => gene_name)
     g.save
  end
end