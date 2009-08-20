#!/usr/bin/env ruby

if ARGV.empty?
  puts "supply a filename"
  exit
end
  
def self.get_num(num)
  weird = (num =~ /00000/)
  n = num.to_f
  return n unless weird
  return Math.log10(n)
end
  
h = {}

f = File.open(ARGV.first)
while(line = f.gets)
  next if line =~ /NULL/
  puts line unless line =~ / = /
  bc, num = line.chomp.split(" = ")
  pvalue = get_num(num)
  if (h.has_key?(bc))
    pvalue = h[bc] if h[bc] < pvalue
    puts "#{bc} = #{pvalue}"
  else
    h[bc] = get_num(num)
  end
end