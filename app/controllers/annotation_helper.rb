class AnnotationHelper
  
  def self.get_annotations(gene_list)   
    return nil if gene_list.nil? or gene_list.empty?
    sql = ["select * from annotations where locus_tag in (?)",gene_list] 
    @annos = Mdv.find_by_sql sql 
  end
  
end