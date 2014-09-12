class Legacy::Story < ActiveRecord::Base
  establish_connection "legacy_sqlserver"
  set_table_name "Story"
end
