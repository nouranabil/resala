class Legacy::Testimonial < ActiveRecord::Base
  establish_connection "legacy_sqlserver"
  set_table_name "Newspaper"
end
