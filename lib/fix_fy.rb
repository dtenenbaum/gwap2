class FixFy
  
  u = User.find_by_email("fylo@systemsbiology.org")
  exps = Experiment.find_all_by_owner_id u.id
  ura3 = Knockout.find_by_gene 'ura3'
  
  syns = Gene.find_by_sql("select name, alias from genes where alias is not null")
  aliases = {}
  syns.each{|i|aliases[i.alias] = i.name}
  
  begin
    Experiment.transaction do
      for exp in exps
        next if exp.name.downcase =~ /nrc-1/
        ko = exp.name.split("_")[2]          
        #blah = (aliases.has_key?ko) ? aliases[ko] : "no match for #{ko}"
        blah = (aliases.has_key?ko) ? aliases[ko] : ko
        if ko =~ /^VNG/
          puts ko
        else
          puts blah
        end
        exp.has_knockouts = true
        exp.knockouts << ura3
        next if ko =~ /ura3/
        knockout = Knockout.find_by_gene(blah)
        if knockout.nil?
          knockout = Knockout.new(:gene => blah)
          knockout.save
        end
        exp.save
        exp.knockouts << knockout
      end
    end
  rescue Exception => ex
    puts ex.message
    puts ex.backtrace
  end

end
