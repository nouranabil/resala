class ActivityCategorySweeper < Sweeper
  observe ActivityCategory
  
  def after_update(activity_category)
    if activity_category.changed?
      expire_action_cache_for("pages", "show", "home")
      expire_all_ctegories_pages
    end
  end
  
  def after_create(activity_category)
    expire_action_cache_for("pages", "show", "home")
    expire_all_ctegories_pages
  end
  
  def after_destroy(activity_category)
    expire_action_cache_for("pages", "show", "home")
    expire_all_ctegories_pages
  end
  
  def expire_all_ctegories_pages
    ActivityCategory.all.each do |activity_category|
      expire_action_cache_for("activity_categories", "show", activity_category.id)
    end
  end
end