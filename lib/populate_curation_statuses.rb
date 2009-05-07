class PopulateCurationStatuses
  CurationStatus.new(:name => 'Not curated', :description => 'Has not been curated.').save
  CurationStatus.new(:name => 'Partially curated', :description => 'Some curation has been done').save
  CurationStatus.new(:name => 'Curated not approved', :description => 'Owner believes curation is complete but experiment has not been reviewed').save
  CurationStatus.new(:name => 'Approved', :description => 'curation has been reviewed and approved').save
  CurationStatus.new(:name => 'Rejected', :description => 'curation has been reviewed and sent back to owner for further curation').save
end