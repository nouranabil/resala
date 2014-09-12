class ActivityCategoriesArticle < ActiveRecord::Base
  scope :articles, lambda{|activities|
    select(:article_id).where("activity_category_id in (#{(activities << 0).join(',')})")
  }
end
