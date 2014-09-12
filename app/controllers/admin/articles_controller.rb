class Admin::ArticlesController < Admin::AdminController
  before_filter :prepare_lists, :only => [:new, :edit, :create, :update]
  before_filter :handle_media_list, :only=>[:create,:update]
  cache_sweeper :article_sweeper, :only=>[:create, :update, :destroy]
  
  def index
    @article_categories = ArticleCategory.all
    @articles = Article.order("created_at desc, id desc")
    @articles = @articles.where(:article_category_id => params[:article_category_id]) unless params[:article_category_id].blank?
    @articles = @articles.search("#{params[:keyword].strip}:*") unless params[:keyword].blank?
    
    @articles = @articles.paginate(:page => params[:page], :per_page=>Article.per_page).all
  end
  
  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def edit
    params[:page] ||= 1
    @article = Article.find(params[:id])
  end

  def create
    @article = Article.new(params[:article])
    update_branches_and_activities
    
    unless params[:article_media].blank?
      params[:article_media].each do |article_media_file|
        media = Media.new(article_media_file.merge(:media_upload_type => "File", :processed=>false))
        media_content_type_split = media.media_content_type.split('/')
        media.media_type = media_content_type_split.first == "image" ? "photo" : media_content_type_split.first
        @article.media << media if media 
      end
    end
    
    begin
      Article.transaction do
        @article.rollback_active_record_state! do
          if @article.save
            if @article.media.files.not_processed.size > 0
              Resque.enqueue(MoveToFacebook, "Article", @article.id, !params[:share_to_facebook].blank?)
            else
              ProvidersShare.new(@article).share unless params[:share_to_facebook].blank?
            end
            redirect_to(admin_articles_path, :notice => t("messages.saved", :name => t("article.article")))
          else
            render :action => "new"
          end
        end
      end
    rescue => e
      logger.error e.inspect
      logger.error e.backtrace.join("\n")
      @article.id = nil
      flash[:alert] = e.message
      render :action => "new"
    end
  end
  
  def update
    @article = Article.find(params[:id])
    @article.attributes = params[:article]
    params[:page] ||= 1
    update_branches_and_activities
    update_media_files
    
    unless params[:article_media].blank?
      params[:article_media].each do |article_media_file|
        media = Media.new(article_media_file.merge(:media_upload_type => "File", :processed=>false))
        media_content_type_split = media.media_content_type.split('/')
        media.media_type = media_content_type_split.first == "image" ? "photo" : media_content_type_split.first
        @article.media << media if media 
      end
    end
    
    if @article.save
      Resque.enqueue(MoveToFacebook, "Article", @article.id) if @article.media.files.not_processed.size > 0
      redirect_to(admin_articles_path(:page=>params[:page]), :notice => t("messages.saved", :name => t("article.article")))
    else
      render :action => "edit" 
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    params[:page] ||= 1
    redirect_to admin_articles_path(:page=>params[:page]), :notice => t("messages.deleted")
  rescue => e
    if e.message =~ /not found/
      @article.update_attribute("facebook_post_id",nil)
      @article.destroy
      flash[:alert] = t("messages.article_deleted_with_facebook_error")
    else
      flash[:alert] = flash[:alert] = t("messages.deletetion_error")
    end 
    redirect_to admin_articles_path(:page=>params[:page])
  end
  
  #######
  private
  #######
  
  def handle_media_list
    begin
      if(params[:article][:media])
        media_list = ActiveSupport::JSON.decode(params[:article][:media])
        media_list = media_list.collect{|m| Media.find_or_create(m['id'] , m['mediaType'], m['thumbnail'])}
        params[:article][:media] = media_list
      end
    rescue
    end
  end
  
  def update_branches_and_activities
    activity_categories = []
    branches = []
    
    params[:activity_categories].each do |activity_category_id|
      activity_category = ActivityCategory.where(:id=>activity_category_id).first
      activity_categories << activity_category if activity_category 
    end unless params[:activity_categories].blank?
    
    params[:branches].each do |branch_id|
      branch = Branch.where(:id=>branch_id).first
      branches << branch if branch 
    end unless params[:branches].blank?
    
    @article.activity_categories = activity_categories
    @article.branches = branches
  end
  
  def update_media_files
    media_files = []
    
    params[:media_files_list].each do |media_id|
      media = Media.where(:id=>media_id).first
      media_files << media if media
    end unless params[:media_files_list].blank?
    
    @article.media << media_files
  end
  
  def prepare_lists
    @article_categories = ArticleCategory.all
    @branches = Branch.all
    @activity_categories = ActivityCategory.all
  end
end
