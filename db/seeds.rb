# -*- coding: utf-8 -*-

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

ArticleCategory.names.each {|name| ArticleCategory.find_or_create_by_name(name) }

cities = ["الإسكندرية", "أسوان", "أسيوط", "البحيرة", "بني سويف", "القاهرة", "الدقهلية", "دمياط", "الفيوم", "الغربية", "الجيزة", "الإسماعيلية", "كفر الشيخ", "مطروح", "المنيا", "المنوفية", "الوادي الجديد", "شمال سيناء", "بورسعيد", "القليوبية", "قنا", "البحر الأحمر", "الشرقية", "سوهاج", "جنوب سيناء", "السويس", "الأقصر", "حلوان", "6 أكتوبر"]
#cities_2 = { "الغربية"=>[30.5238889,31.6488889], "الفيوم"=>[29.3166667,30.8333333], "دمياط"=>[31.4194444,31.815],"القاهرة"=>[30.05,31.25],"بنى سويف"=>[29.0638889,31.0888889],"اسيوط"=>[27.1827778,31.1827778], "اسوان"=>[24.0875,32.8988889], "الإسكندرية" =>[31.1980556,29.9191667], "بورسعيد"=>[31.2666667,32.3] }

puts " ### Creating Cities"
cities.each { |city| City.find_or_create_by_name(city) }
