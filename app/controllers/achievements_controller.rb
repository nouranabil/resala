class AchievementsController < ApplicationController
  load_and_authorize_resource :activity
  load_and_authorize_resource :achievement, :through => :activity
  before_filter :prepare_lists, :only => [:new, :create]
  
  def new
  end
  
  def create
    @activity.volunteers_hours = params[:volunteers_hours]
    @activity.summary = params[:summary]
    
    update_achievements
    update_media_files
    
	  unless params[:activity_media].blank?
		  params[:activity_media].each do |key, activity_media|
		    media = Media.new(activity_media.merge(:media_upload_type => "File", :processed=>false, :status=> Status.requested))
		    unless (media.media_content_type == nil)           
		      media_content_type_split = media.media_content_type.split('/')
		      media.media_type = media_content_type_split.first == "image" ? "photo" : "video"
          begin
		        @activity.media << media
          rescue 
         	  set_cookie("alert", media.errors.full_messages.join)	
         	  render :action => "new"
         	  return
          end
        end   
	    end
	  end      
    
    if @activity.save
      set_cookie("notice", t("messages.activity_update"))
      redirect_to volunteer_activity_path(@activity.user, @activity)
    else
      @achievements = @activity.achievements
      # set_cookie("alert", t("messages.activity_not_closed"))
      render :action => "new"
    end
  end
  
  #######
  private
  #######
  
  def update_achievements
    achievements = []
    
    params[:activity_achievements].each do |activity_achievement|
      achievement = Achievement.new(activity_achievement[1].merge(:activity_id => @activity.id))
      achievements << achievement if achievement
    end unless params[:activity_achievements].blank?
    @activity.achievements = achievements
  end
  
  def update_media_files
    media_files = []
    
    params[:media_files_list].each do |media_id|
      media = Media.where(:id=>media_id).first
      media_files << media if media
    end unless params[:media_files_list].blank?
    
    @activity.media = media_files
  end
  
  def prepare_lists
  	#@activities_media = ActivitiesMedia.new
    @activity = Activity.find params[:activity_id]
    @achievement = Achievement.new
    @achievements_types = AchievementsType.order("name")
    @achievements = @activity.achievements
  end
end
