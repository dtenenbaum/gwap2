# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090922232322) do

  create_table "authorizations", :force => true do |t|
    t.integer  "user_id",       :limit => 11
    t.integer  "group_id",      :limit => 11
    t.integer  "experiment_id", :limit => 11
    t.string   "permission"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "citations", :force => true do |t|
    t.integer "paper_id",      :limit => 11
    t.integer "experiment_id", :limit => 11
  end

  create_table "condition_tags", :force => true do |t|
    t.integer "condition_id", :limit => 11
    t.string  "tag"
  end

  create_table "conditions", :force => true do |t|
    t.integer  "experiment_id",        :limit => 11
    t.string   "name"
    t.integer  "sequence",             :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_data",                           :default => true
    t.integer  "forward_slide_number", :limit => 11
    t.integer  "reverse_slide_number", :limit => 11
    t.integer  "is_duplicate_of",      :limit => 11
  end

  create_table "controlled_vocab_items", :force => true do |t|
    t.string   "name"
    t.boolean  "approved"
    t.integer  "parent_id",  :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "curation_statuses", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "data_types", :force => true do |t|
    t.string "name"
  end

  create_table "environmental_perturbations", :force => true do |t|
    t.integer "experiment_id", :limit => 11
    t.string  "perturbation"
  end

  create_table "experiment_properties", :force => true do |t|
    t.integer  "experiment_id", :limit => 11
    t.integer  "name",          :limit => 11
    t.string   "string_value"
    t.integer  "int_value",     :limit => 11
    t.float    "float_value"
    t.integer  "units_id",      :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "experiment_tags", :force => true do |t|
    t.integer "experiment_id",   :limit => 11
    t.string  "tag"
    t.boolean "auto"
    t.boolean "is_alias"
    t.string  "alias_for"
    t.integer "tag_category_id", :limit => 11
    t.integer "owner_id",        :limit => 11
  end

  create_table "experiments", :force => true do |t|
    t.string   "name"
    t.string   "reference_sample_id"
    t.integer  "reference_to",             :limit => 11
    t.string   "sbeams_project_id"
    t.string   "sbeams_project_timestamp"
    t.integer  "gwap1_id",                 :limit => 11
    t.string   "orig_filename"
    t.integer  "platform_id",              :limit => 11
    t.text     "description"
    t.string   "lab_notebook_number"
    t.integer  "lab_notebook_page",        :limit => 11
    t.date     "date_performed"
    t.date     "date_gwap1_imported"
    t.integer  "owner_id",                 :limit => 11
    t.integer  "importer_id",              :limit => 11
    t.boolean  "has_knockouts"
    t.boolean  "has_overexpression"
    t.boolean  "has_environmental"
    t.integer  "technical_replicate",      :limit => 11
    t.integer  "biological_replicate",     :limit => 11
    t.boolean  "conditions_on_x_axis",                   :default => true
    t.integer  "species_id",               :limit => 11
    t.integer  "parent_strain_id",         :limit => 11
    t.integer  "curation_status_id",       :limit => 11
    t.boolean  "is_private"
    t.boolean  "is_time_series"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "uses_probe_numbers"
    t.integer  "growth_media_recipe_id",   :limit => 11
    t.boolean  "has_tracks"
    t.boolean  "is_control",                             :default => false
  end

  create_table "features", :force => true do |t|
    t.integer "track_id",     :limit => 11
    t.float   "value"
    t.integer "data_type",    :limit => 11
    t.integer "gene_id",      :limit => 11
    t.integer "location_id",  :limit => 11
    t.integer "condition_id", :limit => 11
    t.integer "sequence_id",  :limit => 11
    t.integer "start",        :limit => 11
    t.integer "end",          :limit => 11
    t.boolean "strand"
  end

  add_index "features", ["gene_id"], :name => "index_features_on_gene_id"
  add_index "features", ["condition_id"], :name => "index_features_on_condition_id"
  add_index "features", ["data_type"], :name => "index_features_on_data_type"

  create_table "gene_to_position_maps", :force => true do |t|
    t.integer  "platform_id", :limit => 11
    t.string   "gene"
    t.integer  "start",       :limit => 11
    t.integer  "end",         :limit => 11
    t.string   "strand"
    t.integer  "probe_start", :limit => 11
    t.integer  "probe_end",   :limit => 11
    t.string   "molecule"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "gene_name"
  end

  create_table "genes", :force => true do |t|
    t.string "name"
    t.string "alias"
  end

  add_index "genes", ["name"], :name => "index_genes_on_name"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "growth_media_recipes", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ingredient_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "knockout_associations", :force => true do |t|
    t.integer "knockout_id",   :limit => 11
    t.integer "experiment_id", :limit => 11
  end

  create_table "knockouts", :force => true do |t|
    t.string   "gene"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ranking",     :limit => 11
    t.string   "control_for"
    t.integer  "parent_id",   :limit => 11
  end

  create_table "locations", :force => true do |t|
    t.integer "start",       :limit => 11
    t.integer "end",         :limit => 11
    t.string  "strand"
    t.integer "replicon_id", :limit => 11
  end

  create_table "nav_tree_items", :force => true do |t|
    t.integer "parent_id",     :limit => 11
    t.string  "name"
    t.integer "leaf_id",       :limit => 11
    t.integer "level",         :limit => 11
    t.integer "experiment_id", :limit => 11
  end

  create_table "observations", :force => true do |t|
    t.integer  "condition_id",        :limit => 11
    t.integer  "name_id",             :limit => 11
    t.string   "string_value"
    t.integer  "int_value",           :limit => 11
    t.float    "float_value"
    t.integer  "units_id",            :limit => 11
    t.boolean  "is_measurement"
    t.boolean  "is_time_measurement"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "overexpressions", :force => true do |t|
    t.integer  "experiment_id", :limit => 11
    t.string   "tag"
    t.string   "gene"
    t.string   "plasmid"
    t.string   "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ranking",       :limit => 11
    t.string   "control_for"
    t.float    "amount"
  end

  create_table "papers", :force => true do |t|
    t.string "title"
    t.string "url"
    t.string "authors"
    t.text   "abstract"
    t.string "short_name"
  end

  create_table "platforms", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recipe_ingredients", :force => true do |t|
    t.integer  "growth_media_recipe_id", :limit => 11
    t.string   "name"
    t.string   "value"
    t.string   "value2"
    t.integer  "ingredient_category_id", :limit => 11
    t.string   "amount"
    t.integer  "units_id",               :limit => 11
    t.integer  "units2_id",              :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reference_samples", :force => true do |t|
    t.string   "name"
    t.date     "date_created"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "replicons", :force => true do |t|
    t.integer "species_id", :limit => 11
    t.string  "name"
  end

  create_table "search_terms", :force => true do |t|
    t.string   "word"
    t.integer  "experiment_id", :limit => 11
    t.integer  "condition_id",  :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sequences", :force => true do |t|
    t.string  "name"
    t.integer "species_id", :limit => 11
  end

  create_table "species", :force => true do |t|
    t.string "name"
    t.string "alternate_name"
  end

  create_table "tag_categories", :force => true do |t|
    t.string "category_name"
  end

  create_table "tracks", :force => true do |t|
    t.integer  "condition_id", :limit => 11
    t.integer  "type",         :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "units", :force => true do |t|
    t.integer  "parent_id",  :limit => 11
    t.string   "name"
    t.boolean  "approved"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password"
    t.date     "last_login_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "approved"
  end

  create_table "users_groups", :id => false, :force => true do |t|
    t.integer "user_id",  :limit => 11
    t.integer "group_id", :limit => 11
  end

end
