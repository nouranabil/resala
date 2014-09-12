class Admin::ActivitiesController < Admin::AdminController
  helper_method :sort_column, :sort_direction
  before_filter :handle_media_list, :only=>[:update]
  before_filter :prepare_lists, :only => [:show,:update,:close]
  before_filter :verify_date_time_params, :only => ':update'
  
  def index
    if params[:activity_status].blank?
      @activities = Activity
    else
      @activities = Activity.where("status = ?", params[:activity_status])
    end
    @activities = @activities.order(sort_column + ' ' + sort_direction).paginate(:page => params[:page], :per_page=>Activity.per_page)
  end
  
  def update
    @activity = Activity.find(params[:id])
    
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
    
    update_activities
    update_branches
    
    #update_achievements and handle photos from facebook
    if @activity.update_attributes(params[:activity])
      flash[:notice] = t("messages.activity_update")
    else
      flash[:alert] = t("messages.failed")
    end
    
    #Photos
    #handle photos from server
    update_media_files
    #handle photos from user machine
    unless params[:activity_media].blank?
      params[:activity_media].each do |activity_media_file|
        media = Media.new(activity_media_file.merge(:media_upload_type => "File", :processed=>false))
        media_content_type_split = media.media_content_type.split('/')
        media.media_type = media_content_type_split.first == "image" ? "photo" : media_content_type_split.first
        @activity.media << media if media 
      end
    end
    @activity.save
    #upload photos to facebook
    Resque.enqueue(MoveToFacebook, "Activity", @activity.id) if @activity.media.files.not_processed.size > 0
    
    @activity = Activity.find(params[:id])
    render :action=>:show
  end
  
  def publish
    @activity = Activity.find(params[:id])
    @url = volunteer_activity_path(@activity.user,@activity,:only_path=>false)
    @notification_url = activity_path(@activity,:only_path=>false)
    @activity.attributes = params[:activity]
    branch_only = (params[:branch_only] == "true")
    email_sent = true
    unless @activity.publish!(@url,@notification_url,branch_only)
      email_sent = false
    end
    params[:page] ||= 1 
    flash[:notice] = t('messages.activity_published')
    flash[:notice] <<= t('messages.email_sending_failed') if !email_sent
    redirect_to :action=> :index, :page=>params[:page]
  end
  
  def announce
    @activity = Activity.find(params[:id])
    @activity.update_attributes(params[:activity])
    @activity.announce!(:facebook_announce=> (params[:activity][:facebook_announce] != '0'),
                        :email_notifications=> (params[:activity][:email_notifications] != '0'),
                        :branch_only=> params[:branch_only] ||  false,
                        :facebook_post_message => @activity.facebook_post_message)
    flash[:notice] = t('messages.activity_announced')
    redirect_to admin_activity_path(@activity)
  end
  
  def reject
    @activity = Activity.find(params[:id])
    @activity.update_attributes(params[:activity])
    @activity.reject!(volunteer_activity_path(@activity.user,@activity,:only_path=>false))
    params[:page] ||= 1 
    flash[:notice] = t('messages.activity_rejected')
    redirect_to :action=> :index, :page=>params[:page]
  end
  
  def show
    @activity = Activity.find(params[:id])
  end
  
  def members
    @activity = Activity.find(params[:id])
    volunteers_sort_column = Volunteer.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    @volunteers = params[:accepted_only]=="true" ? @activity.accepted_volunteers : @activity.volunteers
    @volunteers = @volunteers.order(volunteers_sort_column + ' ' + sort_direction).paginate(:page => params[:page], :per_page=>Volunteer.per_page)
    render :partial=>'admin/volunteers/volunteers', :locals=>{:volunteers=>@volunteers,:url=>members_admin_activity_path(@activity)}, :layout=>false
  end
  
  def close
    @activity = Activity.find(params[:id])
    # accept / reject    
    if params[:decision] == 'accept'
      previous_state = @activity.status
      if @activity.accept_close!(volunteer_activity_path(@activity.user,@activity,:only_path=> false) ,activity_url(@activity,:only_path=> false),params[:post_to_facebook],params[:facebook_text])
        flash[:notice] = (previous_state == ActivitiesStatus.request_close ? t('messages.activity_closed') : t('messages.activity_cancelled'))
      else
        flash[:alert] = (previous_state == ActivitiesStatus.request_close ? t('messages.activity_close_failed') : t('messages.activity_cancel_failed'))
      end
    elsif params[:decision] == 'reject'
      previous_state = @activity.status
      if @activity.reject_close!(volunteer_activity_path(@activity.user,@activity,:only_path=> false), params[:rejection_reason])
        flash[:notice] = (previous_state == ActivitiesStatus.request_close ? t('messages.activity_close_rejected') : t('messages.activity_cancel_rejected'))
      else
        flash[:alert] = (previous_state == ActivitiesStatus.request_close ? t('messages.activity_close_reject_failed') : t('messages.activity_cancel_reject_failed'))
      end
    end
    render :action=>:show
  end
  
  def email_counts
    categories = params[:activity] && params[:activity][:email_notifications] == "1"
    if params[:activity_id]
      @recipients_count = Activity.find(params[:activity_id]).email_counts(categories , params[:branch_only])
    else
      @recipients_count = Activity.email_counts(categories ? params[:activity_categories] : [], 
                                                params[:branch_only] ? params[:branches] : [])
    end
    render :partial=>"shared/email_counts", :locals=>{:count=> @recipients_count}
  end
  
  #######
  private
  #######
  def handle_media_list
    begin
      if(params[:activity][:media])
        media_list = ActiveSupport::JSON.decode(params[:activity][:media])
        media_list = media_list.collect{|m| Media.find_or_create(m['id'] , m['mediaType'], m['thumbnail'])}
        params[:activity][:media] = media_list
      end
    rescue
      params[:activity][:media] = []
    end
  end
  
  def update_media_files
    media_files = []
    params[:media_files_list].each do |media_id|
      media = Media.where(:id=>media_id).first
      media.status = Status.accepted
      media_files << media if media
    end unless params[:media_files_list].blank?
    @activity.media << media_files
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
  
  def prepare_lists
    @activity_categories = ActivityCategory.all
    @branches = Branch.branches_list
  end
  
  def verify_date_time_params
    if [params['activity'] , params['activity']['start_date(1i)'] , params['activity']['start_date(2i)'] , params['activity']['start_date(3i)']].all?(&:present?)
      params['activity']['start_date(4i)'] ||= '00'
      params['activity']['start_date(5i)'] ||= '00'
    else
      params['activity']['start_date(1i)'] = params['activity']['start_date(2i)'] = params['activity']['start_date(3i)'] = params['activity']['start_date(4i)'] = params['activity']['start_date(5i)'] = ""
    end
  end
    
  def sort_column
    Activity.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end  
    
  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "desc"
  end 
end
