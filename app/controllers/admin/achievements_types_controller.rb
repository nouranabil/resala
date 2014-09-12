class Admin::AchievementsTypesController < Admin::AdminController
  def index
    @achievements_types = AchievementsType.order("created_at desc")
  end
  
  def new
    @achievements_type = AchievementsType.new
  end

  def edit
    @achievements_type = AchievementsType.find(params[:id])
  end

  def create
    @achievements_type = AchievementsType.new(params[:achievements_type])
    
    if @achievements_type.save
      redirect_to(admin_achievements_types_path, :notice => t("messages.saved", :name => t("achievements_type.achievements_type")) )
    else
      render :action => "new"
    end
  end

  def update
    @achievements_type = AchievementsType.find(params[:id])

    if @achievements_type.update_attributes(params[:achievements_type])
      redirect_to(admin_achievements_types_path, :notice => t("messages.saved", :name => t("achievements_type.achievements_type")))
    else
      render :action => "edit"
    end
  end

  def destroy
    @achievements_type = AchievementsType.find(params[:id])
    @achievements_type.destroy
    
    redirect_to admin_achievements_types_path, :notice => t("messages.deleted")
  end
end