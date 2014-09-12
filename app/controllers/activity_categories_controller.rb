class ActivityCategoriesController < ApplicationController
  caches_action :show, :layout=>true, :expires_in=>CACHE_EXPIRES_IN.call, :if => Proc.new{|x| params[:legacy].blank? }
  
  def index
    redirect_to ActivityCategory.latest.first
  end
  
  def show
    unless params[:legacy].blank?
      @activity_category = ActivityCategory.find_by_legacy_id(params[:id])
      redirect_to @activity_category if @activity_category
    end
    @activity_category ||= ActivityCategory.find(params[:id])
    @activity_categories = ActivityCategory.latest
    @news = @activity_category.articles.latest.news.limit(5)
    @query = Media.construct_query(:media_type=>'photos',:owner_id=>@activity_category.id,:owner_type=>'activity',:page=>1)
  end
  
end