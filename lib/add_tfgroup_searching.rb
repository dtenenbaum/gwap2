#!/usr/bin/env ruby

unless ARGV.size == 1
  puts "supply name of tfgroups.noa file"
  exit
end

in_file = File.open(ARGV.first)

tfgroups = {}
bygene = {}

while(line = in_file.gets)
  next unless line =~ /TFGROUP/
  k,v = line.chomp.split(" = ")
  values = v.gsub("(","").gsub(")","").split("::")
  tfgroups[k] = values
  for gene in values
    bygene[gene] = [] unless bygene.has_key?gene
    bygene[gene] << k
  end
end

                     
puts "tfGroupMembers"
bygene.each_pair do |k,v|
  puts "#{k} = (#{v.join("::")})"
end