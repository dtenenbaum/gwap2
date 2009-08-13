class GeoExtraInfo
  f = File.open("#{RAILS_ROOT}/geo_extra_info.txt")
  while (line = f.gets)
    line.chomp!
    num = line.split(" ").last.to_i
    cond = Condition.find_by_sql("select * from conditions where forward_slide_number = #{num} or reverse_slide_number = #{num}").first
    puts "#{line}\t#{cond.name}"
  end
end