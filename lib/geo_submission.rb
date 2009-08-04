class GeoSubmission
  conds_to_submit = Condition.find_by_sql("select * from conditions where (name like '%pq%' or name like '%h2o2%') and name not like '%50mM%'  and forward_slide_number is not null order by name")
  
  
  
  if (ARGV.size != 1)
    puts "usage: #{$0} sample_header_file > outputfile"
    exit
  end


@dye_forward = "546"
@dye_reverse = "647"

@template = ''                        

                                      

def self.fill_it(slide_num, forward, time, od) 
  fillme = @template.dup    
  fillme.gsub!("$$ARRAY_ID$$", slide_num)      
  if (od.nil?)
    fillme.gsub!("$$CONDITION$$", "t:#{time.string_value} min.")
  else
    fillme.gsub!("$$CONDITION$$", "OD:#{od.string_value}, t:#{time.string_value} min.")
    #fillme.gsub!("$$OD$$", od.string_value)
  end

  if (forward)
    fillme.gsub!("$$DYE1$$", @dye_forward)
    fillme.gsub!("$$DYE2$$", @dye_reverse)
  else
    fillme.gsub!("$$DYE1$$", @dye_reverse)
    fillme.gsub!("$$DYE2$$", @dye_forward)
  end
 
  puts fillme
  puts
  puts
end

File.open(ARGV.first).each do |line|
  @template += line
end
      
#File.open(ARGV.last).each do |line|    
  #next unless line =~ /^[0-9]/
  #sbeams_id, forward_slide, reverse_slide, condition = line.chomp.split("\t")
  #time, od = get_time_and_od(condition) 
#  blah, forward_slide, reverse_slide, time, od = line.chomp.split("\t")
##  fill_it(forward_slide, true, time, od)
 # fill_it(reverse_slide, false, time, od)
#end

time_id = 6
od_id = 7
slidenums = {}

conds_to_submit.each do |cond|
  time = cond.observations.detect{|i|i.name_id == time_id}
  od = cond.observations.detect{|i|i.name_id == od_id}   
  fill_it(cond.forward_slide_number.to_s, true, time, od) unless slidenums.has_key?(cond.forward_slide_number)
  fill_it(cond.reverse_slide_number.to_s, false, time, od) unless slidenums.has_key?(cond.reverse_slide_number)
  slidenums[cond.forward_slide_number] = 1
  slidenums[cond.reverse_slide_number] = 1
end

end