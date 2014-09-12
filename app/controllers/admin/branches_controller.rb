class Admin::BranchesController < Admin::AdminController
  before_filter :prepare_lists, :only => [:new, :edit, :create, :update]
  before_filter :handle_media_list, :only=>[:create,:update]
  # cache_sweeper :branch_sweeper, :only=>[:create, :update, :destroy]
  
  def index
    @branches = Branch.all
  end
  
  def new
    @branch = Branch.new
  end
  
  def show
    @branch = Branch.find(params[:id])
  end
  
  def edit
    @branch = Branch.find(params[:id])
    @lat = @branch.latitude 
    @lng = @branch.longitude
    @marked = (@lat && @lng)
  end
  
  def update
    @branch = Branch.find(params[:id])
    update_activities
    if @branch.update_attributes(params[:branch])
      redirect_to(admin_branches_path, :notice => t("messages.saved", :name => t("branch.branch")))
    else
      render :action => "edit"
    end
  end
  
  def create
    @branch = Branch.new(params[:branch])
    update_activities
    if @branch.save
      redirect_to(admin_branches_path, :notice => t("messages.saved", :name => t("branch.branch")))
    else
      render :action => "new"
    end
  end
  
  def destroy
    if params[:branch][:alternative_branch] == ""
      redirect_to admin_branches_url, :alert => t("messages.select_alternate_branch")
    else
      @branch = Branch.find(params[:id])
      @branch.alternative_branch = Branch.where(:id => params[:branch][:alternative_branch]).first
      authorize! :destroy, @branch
      if @branch.destroy
        redirect_to admin_branches_url , :notice => t("messages.deleted")
      else
        redirect_to admin_branches_url , :alert => t("messages.branch_deletion_failed")
      end
    end
  end

  #######
  private
  #######
  
  def handle_media_list
    begin
      if(params[:branch][:media])
        media_list = ActiveSupport::JSON.decode(params[:branch][:media])
        media_list = media_list.collect{|m| Media.find_or_create(m['id'] , m['mediaType'], m['thumbnail'])}
        params[:branch][:media] = media_list
      end
    rescue
    end
  end
  
  def update_activities
    activity_categories = []
    
    params[:activity_categories].each do |activity_category_id|
      activity_category = ActivityCategory.where(:id=>activity_category_id).first
      activity_categories << activity_category if activity_category 
    end unless params[:activity_categories].blank?
    
    @branch.activity_categories = activity_categories
  end
  
  def prepare_lists
    @cities_for_select = City.all
    @activity_categories = ActivityCategory.all
  end
end
