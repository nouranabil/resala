class ActivityCategoriesVolunteer < ActiveRecord::Base
  scope :volunteers, lambda{|activity_category_id|
    select(:volunteer_id).where("activity_category_id = #{activity_category_id}")
  }
end
