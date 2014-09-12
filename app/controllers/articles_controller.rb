class ArticlesController < ApplicationController
  
  def show
    @article.increment_views_count
    @related_articles = @article.related_articles
    @article_activity_categories = @article.activity_categories
    @article_branches = @article.branches
    @query = Media.construct_query(:media_type=>'photos',:owner_id=>@article.id,:owner_type=>'article',:page=>1)
  end
  
  def index
    @articles = @articles.paginate(:page => params[:page], :per_page=>Article.per_page)
  end
  
  def search
    @articles = @articles.search("#{params[:keyword].strip}:*") unless params[:keyword].blank?
    @articles = @articles.paginate(:page => params[:page], :per_page=>Article.per_page)
  end
end
