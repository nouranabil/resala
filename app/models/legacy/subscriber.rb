class Legacy::Subscriber < ActiveRecord::Base
  establish_connection "legacy_sqlserver"
  set_table_name "Subscriber"
end
