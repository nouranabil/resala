Factory.define :activity, :class => Activity do |a|
  a.sequence(:title){|x| "title_#{x}" }
  a.description                   "description"
  a.required_volunteers_count     "3"
  #TODO: create using Factory
  #a.activity_categories           [ActivityCategory.create(:name=>"activity_#{Time.now.to_i}", :front_photo_id=>"123", :short_description=>"short_description")]
end