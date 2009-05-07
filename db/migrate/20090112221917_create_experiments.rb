class CreateExperiments < ActiveRecord::Migration
  def self.up
    create_table :experiments do |t|
         t.column :name, :string
         t.column :reference_sample_id, :string
         t.column :reference_to, :integer
         t.column :sbeams_project_id, :string
         t.column :sbeams_project_timestamp, :string
         t.column :gwap1_id, :integer
         t.column :orig_filename, :string
         t.column :platform_id, :integer
         t.column :description, :text
         t.column :lab_notebook_number, :string
         t.column :lab_notebook_page, :integer
         t.column :date_performed, :date
         # date imported will be shown by timestamp columns
         t.column :date_gwap1_imported, :date
         t.column :owner_id, :integer
         t.column :importer_id, :integer
         t.column :has_knockouts, :boolean
         t.column :has_overexpression, :boolean
         t.column :has_environmental, :boolean
         t.column :replicate, :integer
         t.column :biological_replicate, :integer
         t.column :conditions_on_x_axis, :boolean, :default => true
         t.column :species_id, :integer # what does this reference? ncbi? or another table?
         t.column :parent_strain_id, :integer
         t.column :curation_status_id, :integer
         t.column :is_private, :boolean
         t.column :is_time_series, :boolean
      t.timestamps
    end
  end

  def self.down
    drop_table :experiments
  end
end
