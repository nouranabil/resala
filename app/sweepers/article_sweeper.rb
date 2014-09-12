class ArticleSweeper < Sweeper
  observe Article
  
  def after_update(article)
    expire_action_cache_for(article.article_category.en_name, "show", article.id) if article.changed?
    if first_articles_page(article).collect{|a| a.id}.include?(article.id)
      expire_action_cache_for(article.article_category.en_name, "index", nil,  1)
      expire_action_cache_for("pages", "show", "home")
    end
    if article.article_category.en_name == "news"
      expire_action_cache_for("news", "index", nil,  1, article.activity_categories.collect{|ac| ac.id} << 0)
    end
  end
  
  def after_create(article)
    expire_action_cache_for(article.article_category.en_name, "index", nil,  first_articles_page(article).total_pages)
    if article.article_category.en_name == "news"
      expire_action_cache_for("pages", "show", "home")
      expire_action_cache_for("news", "index", nil,  1, article.activity_categories.collect{|ac| ac.id} << 0)
    end
  end
  
  def after_destroy(article)
    expire_action_cache_for(article.article_category.en_name, "index", nil,  first_articles_page(article).total_pages)
    if article.article_category.en_name == "news"
      expire_action_cache_for("pages", "show", "home")
      expire_action_cache_for("news", "index", nil,  1, article.activity_categories.collect{|ac| ac.id} << 0)
    end
  end
  
  #######
  private
  #######
  
  def first_articles_page(article)
    @articles || @articles =  Article.where(:article_category_id=>article.article_category_id).latest.paginate(:page => 1, :per_page=>Article.per_page)
  end
  
  def expire_action_cache_for(obj_controller, obj_action, obj_id = nil, pages_count = nil, activity_categories = [0])
    if obj_id
      expire_action(:controller => "/#{obj_controller}", :action => obj_action, :id => obj_id)
    else
      pages_count.to_i.times do |page_num|
        activity_categories.each do |activity_category_id|
          expire_action(:controller=>"/#{obj_controller}", :action=>obj_action, :page=>page_num+1, :activity_category_id=>activity_category_id)
        end 
      end
    end
  end
  
end