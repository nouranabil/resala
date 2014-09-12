class VolunteersController < ApplicationController
  caches_action :show, :layout=>true, :expires_in=>CACHE_EXPIRES_IN.call
#  caches_action :index, :layout=>true, :cache_path => :cache_path.to_proc, :expires_in=>CACHE_EXPIRES_IN.call
  cache_sweeper :volunteer_sweeper, :only=>[:create, :update]
  
  load_resource :except => [:dashboard, :previous_activities, :upcoming_activities, :activities, :activity, :show, :request_activities_authority, :activities_authority, :update_join_activity]
  authorize_resource :except => [:dashboard, :previous_activities, :upcoming_activities, :activities, :activity, :show, :request_activities_authority, :activities_authority, :update_join_activity]
  before_filter :prepare_lists, :only => [:new, :create, :edit, :update, :index]
  
  def index
    @volunteers = Volunteer.active
    #filter by category
    @volunteers = @volunteers.joins('INNER JOIN "activity_categories_volunteers" ON "users".id = "activity_categories_volunteers".volunteer_id').
                              where("\"activity_categories_volunteers\".activity_category_id = ? ",params[:activity_category_id]) unless params[:activity_category_id].blank?
    #filter by branch
    @volunteers = @volunteers.where("\"users\".branch_id = ? ", params[:branch_id]) unless params[:branch_id].blank?
    
    #sorting
    @volunteers = @volunteers.order(sort_column + ' ' + sort_direction)
    
    #filter by facebook friends
    if params[:fb_friends]
      friend_ids = cookies[:friend_ids] || ""
      @volunteers = @volunteers.where(:uid=>friend_ids.split('|'))
    end
    
    #pagination
    @volunteers = @volunteers.paginate(:page => params[:page], :per_page=>Volunteer.per_page)
  end
  
  def show
    @volunteer = User.find(params[:id])
    authorize! :show, @volunteer
  end
  
  def new
    @volunteer = Volunteer.new(session[:auth])
  end
  
  def edit 
    @volunteer = Volunteer.find(params[:id])
  end  
  
  def create
    @volunteer = Volunteer.new(params[:volunteer])
    update_activities
    
    if @volunteer.save
      ProvidersShare.new(nil, false, @volunteer).volunteer_share if @volunteer.post_updates_to_facebook
      session[:user_id] = @volunteer.id
      set_cookie("notice", t("messages.volunteer_added"))
      redirect_to(activities_path)
    else
      render :action => "new"
    end
  end
  
  def update
    @volunteer = Volunteer.find(params[:id])
    update_days
    @volunteer.attributes = params[:volunteer]
    update_activities
    
    if @volunteer.save
      set_cookie("notice", t("messages.volunteer_updated"))
      redirect_to @volunteer
    else
      render :action => "edit"
    end
  end
  
  def request_activities_authority
    @volunteer = current_user
    authorize! :request_activities_authority, @volunteer
    
    @activities_authority = ActivitiesAuthority.new(:volunteer => current_user, :request_activities=>[])
    @activity_categories = ActivityCategory.all
  end
  
  def activities_authority
    @volunteer = current_user
    
    params[:activity_categories] ||= []
    @activities_authority = ActivitiesAuthority.new(:volunteer => current_user, :request_activities=>params[:activity_categories], :existing_role=>params[:existing_role])
    
    if @activities_authority.save
      set_cookie("notice", t("messages.activities_authority_sent"))
      redirect_to dashboard_volunteer_path(current_user)
    else
      @activity_categories = ActivityCategory.all
      render :request_activities_authority
    end
    
    # if current_user && (current_user.activities_authority_status == nil || current_user.activities_authority_status == 0)
    #   current_user.update_attribute(:activities_authority_status, ActivitiesAuthorityStatus.requested)
    #   Mailer.activities_authority_requested(current_user).deliver
    #   set_cookie("notice", t("messages.activities_authority_sent"))
    # else
    #   set_cookie("alert", t("messages.activities_authority_sent_before")) if current_user.activities_authority_status == ActivitiesAuthorityStatus.requested
    #   set_cookie("notice", t("messages.activities_authority_sent_and_accepted")) if current_user.activities_authority_status == ActivitiesAuthorityStatus.accepted
    #   set_cookie("alert", t("messages.activities_authority_sent_and_rejected")) if current_user.activities_authority_status == ActivitiesAuthorityStatus.rejected
    # end
    # 
    # redirect_to dashboard_volunteer_path(current_user)
  end
  
  def activities
    @volunteer = User.find(params[:id])
    authorize! :activities, @volunteer
    
    @activities = current_user.activities.latest.paginate(:page => params[:page], :per_page=>Activity.per_page)
  end
  
  def activity
    @volunteer = User.find(params[:id])
    authorize! :activity, @volunteer
    
    @activity = Activity.find(params[:activity_id])
  end
  
  def upcoming_activities
    @volunteer = User.find(params[:id])
    authorize! :upcoming_activities, @volunteer
    
    @activities = Activity.where("id in (#{(ActivitiesRequest.activities(current_user.id).collect{|ar| ar.activity_id} << 0).join(',')})").upcoming.latest.paginate(:page => params[:page], :per_page=>Activity.per_page)
  end
  
  def previous_activities
    @volunteer = User.find(params[:id])
    authorize! :previous_activities, @volunteer
    
    @activities = Activity.where("id in (#{(ActivitiesRequest.activities(current_user.id).collect{|ar| ar.activity_id} << 0).join(',')})").previous.latest.paginate(:page => params[:page], :per_page=>Activity.per_page)
  end
  
  def dashboard
    @volunteer = User.find(params[:id])
    authorize! :dashboard, @volunteer
    
    @my_activities = current_user.activities.not_cancelled.latest.limit(5)
    @upcoming_activities = Activity.where("id in (#{(ActivitiesRequest.activities(current_user.id).collect{|ar| ar.activity_id} << 0).join(',')})").upcoming.latest.limit(5)
    @previous_activities = Activity.where("id in (#{(ActivitiesRequest.activities(current_user.id).collect{|ar| ar.activity_id} << 0).join(',')})").previous.latest.limit(5)
  end
  
  def gateway
  end
  
  def update_join_activity
    @activity_request = ActivitiesRequest.where(:activity_id=>params[:activity_id], :volunteer_id=>params[:id]).first
    raise CanCan::AccessDenied.new(nil, :update_join_activity, Volunteer ) if !@activity_request
    
    params[:accept] ||= "true"
    @volunteer = User.find(params[:id])
    
    @activity_request.status = params[:accept] == "true" ? ActivitiesAuthorityStatus.accepted : ActivitiesAuthorityStatus.rejected
    @activity_request.reject_reason = params["activities_request"]["reject_reason"] if @activity_request.status == ActivitiesAuthorityStatus.rejected
    
    if @activity_request.save
      set_cookie("notice", t("messages.joined_activity"))
    else
      set_cookie("alert", t("messages.not_joined_activity") + ", " + @activity_request.errors.full_messages.join(', '))
    end
    
    Mailer.volunteer_response(@volunteer.id,@activity_request.id).deliver
    redirect_to volunteers_volunteer_activity_path(current_user, @activity_request.activity)
  rescue => e
    set_cookie("alert", e.message)
    raise e if !@activity_request
    redirect_to volunteers_volunteer_activity_path(current_user, @activity_request.activity)
  end
  
  def cache_path
    { :page => params[:page] || 1 }
  end
  
  def volunteer_details
  	@volunteer = User.find(params[:id])
	authorize! :volunteer_details, @volunteer
	render :action=>"show", :layout=>false
  end
  

  #######
  private
  #######
  
  def prepare_lists
    @activity_categories = ActivityCategory.all
    @cities = City.all
    @branches = Branch.branches_list
  end
  
  def update_activities
    activity_categories = []
    
    params[:activity_categories].each do |activity_category_id|
      activity_category = ActivityCategory.where(:id=>activity_category_id).first
      activity_categories << activity_category if activity_category 
    end unless params[:activity_categories].blank?
    
    @volunteer.activity_categories = activity_categories
  end
  
  def update_days
    Day.days.each do |day_en, day_ar|
      @volunteer.send "#{day_en}=", false
    end
  end
  
  def sort_column
    Volunteer.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end  
    
  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "desc"
  end
end
