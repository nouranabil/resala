class Admin::ActivityCategoriesController < Admin::AdminController
  before_filter :handle_media_list, :only=>[:create,:update]
  cache_sweeper :activity_category_sweeper, :only=>[:create, :update, :destroy]
  
  def index
    @activity_categories = ActivityCategory.latest
  end

  def show
    @activity_category = ActivityCategory.find(params[:id])
  end

  def new
    @activity_category = ActivityCategory.new
  end

  def edit
    @activity_category = ActivityCategory.find(params[:id])
  end

  def create
    @activity_category = ActivityCategory.new(params[:activity_category])
    
    if @activity_category.save
      @activity_category.move_to_top
      redirect_to(admin_activity_categories_path, :notice => t("messages.saved", :name => t("activity_category.activity_category")))
    else
      render :action => "new"
    end
  end
  
  def update
    @activity_category = ActivityCategory.find(params[:id])
    if @activity_category.update_attributes(params[:activity_category])
      redirect_to(admin_activity_categories_path, :notice => t("messages.saved", :name => t("activity_category.activity_category")))
    else
      render :action => "edit"
    end
  end

  def destroy
    @activity_category = ActivityCategory.find(params[:id])
    authorize! :destroy, @activity_category
    @activity_category.destroy
    
    redirect_to(admin_activity_categories_url, :notice => t("messages.deleted"))
  end
  
  def update_order
    moved_category = ActivityCategory.find(params[:id])
    if params[:prev_id]!= "-1"
      previous_category = ActivityCategory.find(params[:prev_id])
      moved_category.remove_from_list
      moved_category.insert_at(previous_category.position + 1)
    else
      moved_category.move_to_top
    end
    
    render :nothing => true
  end
  
  #######
  private
  #######
  
  def handle_media_list
    begin
      if(params[:activity_category][:media])
        media_list = ActiveSupport::JSON.decode(params[:activity_category][:media])
        media_list = media_list.collect{|m| Media.find_or_create(m['id'] , m['mediaType'], m['thumbnail'])}
        params[:activity_category][:media] = media_list
      end
    rescue
    end
  end
end
