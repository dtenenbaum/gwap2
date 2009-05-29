class SearchHelper
   def self.full_search(terms)
     return nil if terms.nil? or terms.strip.empty?
     words = terms.strip.split(" ")
     matches = {}
     ids = {}
     for word in words 
       word.strip!
       intermediate_result = MDV.find_by_sql(["select distinct annotation_id, word from searchable_items where word like ?","%#{word}%"])
       for item in intermediate_result
         matches[item.word] = ''
         ids[item.annotation_id] = ''
       end
     end
     raw_locus_tag = MDV.find_by_sql(["select locus_tag from annotations where id in (?) and species_id = 1",ids.keys])   
     locus_tag = raw_locus_tag.map{|i|i.locus_tag} 
     return nil if locus_tag.nil? or locus_tag.empty?
     return matches.keys.sort{|a,b|a.downcase <=> b.downcase}, locus_tag.sort
  end
   
end