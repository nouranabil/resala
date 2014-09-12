class Legacy::News < ActiveRecord::Base
  establish_connection "legacy_sqlserver"
  set_table_name "newsitem"
end
