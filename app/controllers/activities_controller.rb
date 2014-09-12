class ActivitiesController < ApplicationController
  load_resource :except => [:edit, :update, :create]
  authorize_resource :except => [:edit, :update, :create, :notify_comment]
  before_filter :prepare_lists, :only => [:new, :create, :index, :edit, :update]
  before_filter :verify_date_time_params, :only => [:update,:create]
  
  def index
    @activities = Activity.published.upcoming
    @activities = @activities.joins('INNER JOIN "activities_activity_categories" ON "activities".id = "activities_activity_categories".activity_id').
                              where("\"activities_activity_categories\".activity_category_id = ? ",params[:activity_category_id]) unless params[:activity_category_id].blank?
    @activities = @activities.joins('INNER JOIN "activities_branches" ON "activities".id = "activities_branches".activity_id').
                              where("\"activities_branches\".branch_id = ? ", params[:branch_id]) unless params[:branch_id].blank?
    @activities = @activities.search("#{params[:keyword].strip}:*") unless params[:keyword].blank?
    @activities = @activities.order(sort_column + ' ' + sort_direction).paginate(:page => params[:page], :per_page=>Activity.per_page)
  end
  
  def show
    redirect_to :action=> :join_activity if current_user && params[:attempt_to_join]
    @activity = Activity.find(params[:id])
  end
  
  def new
    @activity = Activity.new
    @activity.disclose_volunteers = true 
  end
  
  def edit
    @activity = Activity.find(params[:activity_id])
    authorize! :edit, @activity
  end
  
  def create
    front_photo = params[:activity].delete('front_photo')
    @activity = Activity.new(params[:activity])
    authorize! :create, @activity
    update_activities
    update_branches
    @activity.user = current_user
    
    #uploaded front photo
    unless front_photo.blank?
      activity_media_file = front_photo
      media = Media.new({:media => activity_media_file}.merge(:media_upload_type => "File", :processed=>false))
      media_content_type_split = media.media_content_type.split('/')
      media.media_type = media_content_type_split.first == "image" ? "photo" : media_content_type_split.first
      media.save
      @activity.front_photo = media if media
    end
    params[:activity].delete('front_photo')
    
    @activity.status = ActivitiesStatus.accepted if current_user.admin?
    
    if @activity.save
      if current_user.admin?
        @url = volunteer_activity_path(@activity.user,@activity,:only_path=>false)
        @notification_url = activity_path(@activity,:only_path=>false)
        branch_only = (params[:branch_only] == "true")
        @activity.publish!(@url,@notification_url, branch_only)
    
        set_cookie("notice", t("messages.activity_added_by_admin"))
      else
        set_cookie("notice", t("messages.activity_added"))
      end
      
      redirect_to(dashboard_volunteer_path(current_user))
    else
      render :action => "new"
    end
  end
  
  def update
    @activity = Activity.find(params[:activity_id])
    authorize! :update, @activity
    
    #uploaded front photo
    unless params[:activity][:front_photo].blank?
      activity_media_file = params[:activity][:front_photo]
      media = Media.new({:media => activity_media_file}.merge(:media_upload_type => "File", :processed=>false))
      media_content_type_split = media.media_content_type.split('/')
      media.media_type = media_content_type_split.first == "image" ? "photo" : media_content_type_split.first
      media.save
      @activity.front_photo = media if media
    end
    params[:activity].delete('front_photo')
    
    @activity.attributes = params[:activity]
    update_activities
    update_branches
    
    if @activity.save
      set_cookie("notice", t("messages.updated", :name => t("activity.activity")))
      redirect_to(volunteer_activity_path(@activity.user_id, @activity))
    else
      render :action => "edit"
    end
  end
  
  def join_activity
    @activity = Activity.find(params[:id])
    if !current_user.activities_requests.where(:activity_id=>@activity.id).first && ar=ActivitiesRequest.create!({:activity=>@activity, :volunteer=>current_user})
      ProvidersShare.new(nil, false, ar.volunteer, ar.activity).activity_join_share if ar.volunteer.post_updates_to_facebook
      set_cookie("notice", ar.status == Status.accepted ? t("messages.activity_joined_and_confirmed") : t("messages.activity_joined"))
    else
      set_cookie("alert", t("messages.activity_not_joined"))
    end
    redirect_to @activity
  rescue
    set_cookie("alert", t("messages.activity_not_joined"))
    redirect_to @activity
  end
  
  def quit
    @activity = Activity.find(params[:id])
    if ( ar =current_user.activities_requests.where(:activity_id=>@activity.id).first) && ar.destroy
      set_cookie("notice", t("messages.activity_quit"))
    else
      set_cookie("alert", t("messages.activity_not_quit"))
    end
    redirect_to @activity
  end
  
  def volunteers
    @activity = Activity.find(params[:id])
    if params[:volunteer_id].blank?
      @is_owner = false  
      @activities_requests = @activity.activities_requests.accepted.paginate(:page => params[:page], :per_page=>Volunteer.per_page)
    else
      @is_owner = true
      @activities_requests = @activity.activities_requests.paginate(:page => params[:page], :per_page=>Volunteer.per_page)
    end
  end
  
  def request_close
  	@acitvity = Activity.find(params[:id])
  	@activity.status = params[:request_type] == "end" ? ActivitiesStatus.request_close : ActivitiesStatus.request_cancel

  	if @activity.save
      set_cookie("notice", t("messages.activity_close_requested"))
      redirect_to volunteer_activity_path(@activity.user, @activity)
    else
      set_cookie("alert", t("messages.activity_not_closed"))
      redirect_to volunteer_activity_path(@activity.user, @activity)
    end
  end
  
  def preview
  	@activity = Activity.find(params[:id])
  	@achievements = @activity.achievements
  	authorize! :edit, @activity 
  end
  
  def notify_comment
    Mailer.facebook_comment_notification_email(params[:id], params[:comment_text], params[:commentor_uid],  params[:commentor_name], params[:other_commentors] ).deliver
    render :text => "Email sent"
  end
  
  #######
  private
  #######
  
  def prepare_lists
    @activity_categories = ActivityCategory.all
    @branches = Branch.branches_list
  end
  
  def update_activities
    activity_categories = []
    
    params[:activity_categories].each do |activity_category_id|
      activity_category = ActivityCategory.where(:id=>activity_category_id).first
      activity_categories << activity_category if activity_category 
    end unless params[:activity_categories].blank?
    
    @activity.activity_categories = activity_categories
  end
  
  def update_branches
    branches = []
    
    params[:branches].each do |branch_id|
      branch = Branch.where(:id=>branch_id).first
      branches << branch if branch 
    end unless params[:branches].blank?
    
    @activity.branches = branches
  end
  
  def sort_column
    Activity.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end  
    
  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "desc"
  end
  
  def verify_date_time_params
    if [params['activity'] , params['activity']['start_date(1i)'] , params['activity']['start_date(2i)'] , params['activity']['start_date(3i)']].all?(&:present?)
      params['activity']['start_date(4i)'] ||= '00'
      params['activity']['start_date(5i)'] ||= '00'
    else
      params['activity']['start_date(1i)'] = params['activity']['start_date(2i)'] = params['activity']['start_date(3i)'] = params['activity']['start_date(4i)'] = params['activity']['start_date(5i)'] = ""
    end
  end
end
