class StoriesController < ArticlesController
  caches_action :show, :layout=>true, :expires_in=>CACHE_EXPIRES_IN.call, :if => Proc.new{|x| params[:legacy].blank? }
  caches_action :index, :layout=>true, :cache_path => :cache_path.to_proc, :expires_in=>CACHE_EXPIRES_IN.call
  
  def show
    unless params[:legacy].blank?
      @article = Article.stories.find_by_legacy_id(params[:id])
      redirect_to story_path(@article)
    else
      @article = Article.stories.find params[:id]
      super
    end 
  end
  
  def index
    @articles = Article.stories.latest
    super
  end
  
  def search
    @articles = Article.stories.latest
    super
  end
  
  def cache_path
    { :page => (params[:page] || 1), :activity_category_id => (params[:activity_category_id] || 0) }
  end
  
end