#!/usr/bin/env ruby

# this script has nothing to do with GWAP2, really, but it needs to be somewhere


f = File.open("weights.eda")
while (line = f.gets)
  if line =~ / -/
    line.gsub!(/ -/, " ")
    line.gsub!(/activates/, "represses")
  end
  puts line
end