# -*- coding: utf-8 -*-
class Day
  @@days = {:friday=>"الجمعة", :saturday=>"السبت", :sunday=>"الأحد", :monday=>"الأثنين", :tuesday=>"الثلاثاء", :wednesday=>"الأربعاء", :thursday=>"الخميس"}
  
  def self.all(locl=:en)
    return @@days.values if locl == :ar 
    return @@days.keys
  end
  
  def self.days
    @@days
  end
end