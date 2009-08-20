#!/usr/bin/env ruby
unless ARGV.size == 1
  puts "supply the path to a matrix_output file"
#   exit
end

require 'pp'  
#arrays_dir = "/net/arrays/"
arrays_dir = "/Volumes/Arrays/" 

oligo_files = `ls -1 #{arrays_dir}Slide_Templates/halo_oligo*.map`
  
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

#puts "^#{newest}^"
#exit if true

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

#pp map

f = File.open(ARGV.first)
count = -1
while (line = f.gets)
  count += 1
  next if count < 2
  segs = line.split("\t")
  segs[0] = map[segs[0]]
  segs[1] = map[segs[1]]
  puts segs.join("\t")
end