class Mdv < ActiveRecord::Base
  establish_connection :mdv
  set_table_name "species"
end