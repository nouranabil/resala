class NewsController < ArticlesController
  caches_action :show, :layout=>true, :expires_in=>CACHE_EXPIRES_IN.call, :if => Proc.new{|x| params[:legacy].blank? }
  caches_action :index, :layout=>true, :cache_path => :cache_path.to_proc, :expires_in=>CACHE_EXPIRES_IN.call
  
  def show
    unless params[:legacy].blank?
      @article = Article.news.find_by_legacy_id(params[:id])
      redirect_to news_url(@article)
    else
      @article = Article.news.find params[:id]
      super
    end
  end
  
  def index
    if params[:activity_category_id].blank?
      @articles = Article.news.latest    
    else
      activity_category = ActivityCategory.find(params[:activity_category_id])
      @articles = activity_category.articles.news.latest
    end
    
    super
  end
  
  def search
    @articles = Article.news.latest
    super
  end
  
  def cache_path
    { :page => (params[:page] || 1), :activity_category_id => (params[:activity_category_id] || 0) }
  end
  
end
