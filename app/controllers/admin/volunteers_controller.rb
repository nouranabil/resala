class Admin::VolunteersController < Admin::AdminController
  cache_sweeper :volunteer_sweeper, :only=>[:update, :destroy]
  
  before_filter :prepare_lists, :only => [:edit, :update]
  helper_method :sort_column, :sort_direction
  
  def show
    @volunteer = Volunteer.find(params[:id])
  end
  
  def index
    @volunteers = Volunteer.order(sort_column + ' ' + sort_direction)
    @activity_categories = ActivityCategory.all
    @branches = Branch.order("city_id")
    @from_date = Date.strptime("#{params[:from_date][:year]}-#{params[:from_date][:month]}-#{params[:from_date][:day]}") if params[:from_date] && params[:from_date].keys.all?{|k| !params[:from_date][k].blank?}
    @to_date   = Date.strptime("#{params[:to_date][:year]  }-#{params[:to_date][:month]  }-#{params[:to_date][:day]  }") if params[:to_date]   && params[:to_date].keys.all?  {|k| !params[:to_date][k].blank?}
    
    @volunteers = @volunteers.for_activity_category(params[:volunteer_activity_category_id]) unless params[:volunteer_activity_category_id].blank?
    @volunteers = @volunteers.where(:branch_id => params[:volunteer_branch_id]) unless params[:volunteer_branch_id].blank?
    @volunteers = @volunteers.where(:activities_authority_status => params[:activities_authority_status]) unless params[:activities_authority_status].blank?
    @volunteers = @volunteers.where('created_at >= ?', @from_date) if @from_date 
    @volunteers = @volunteers.where('created_at <= ?', @to_date + 1.day) if @to_date
    @volunteers = @volunteers.search("#{params[:keyword].strip}:*") unless params[:keyword].blank?
    @volunteers = @volunteers.paginate(:page => params[:page], :per_page=>Volunteer.per_page).all
  end
  
  def edit
    @volunteer = Volunteer.find(params[:id])
    @branches = @volunteer.city.branches
    params[:page] ||= 1
  end
  
  def update
    @volunteer = Volunteer.find(params[:id])
    @volunteer.graduated = false
    @volunteer.post_updates_to_facebook = false
    @volunteer.get_activities_updates = false
    @volunteer.blood_donation = false
    params[:page] ||= 1
    
    update_days
    @volunteer.attributes = params[:volunteer]
    update_activities
    
    if @volunteer.save
      redirect_to(admin_volunteers_path(:page=>params[:page]), :notice => t("messages.saved", :name => t("volunteer.volunteer")))
    else
      @branches = @volunteer.branch.city.branches if @volunteer.branch
      @branches ||= @volunteer.city.branches if @volunteer.city
      render :action => "edit"
    end
  end
  
  def destroy
    @volunteer = Volunteer.find(params[:id])
    params[:suspended] ||= true
    @volunteer.update_attribute :suspended, params[:suspended]
    params[:page] ||= 1
    
    msg = params[:suspended] == true ? t("messages.suspended") : t("messages.unsuspended")
    redirect_to admin_volunteers_path(:page=>params[:page]), :notice => msg
  rescue => e
    flash[:alert] = e.message
    redirect_to admin_volunteer_path(:page=>params[:page])
  end
  
  def update_activities_authority_status
    @volunteer = Volunteer.find(params[:id])
    params[:accept] ||= "true"
    params[:page] ||= 1
    
    @volunteer.update_attribute :activities_authority_status, (params[:accept] == "true" ? ActivitiesAuthorityStatus.accepted : ActivitiesAuthorityStatus.rejected)
    if(params[:accept] == "true" && params[:activity_categories])
      acs = params[:activity_categories].collect(&:to_i).uniq.join(",")
      @volunteer.update_attribute(:request_activities,acs)
    end
    Mailer.activities_authority_status_updated(@volunteer.id).deliver
    
    redirect_to admin_volunteers_path(:page=>params[:page]), :notice => t("messages.updated", :name => t("volunteer.volunteer"))
  rescue => e
    flash[:alert] = e.message
    redirect_to admin_volunteer_path(:page=>params[:page])
  end
  
  def authority_volunteer_details
	@volunteer = User.find(params[:id])
	unless @volunteer.request_activities == nil
		@activities = ActivityCategory.find(@volunteer.request_activities.split(','))
	end
	@existing_role = @volunteer.existing_role
	render :partial => "authority_volunteer_details", :layout=>false
  end
  
  #######
  private
  #######
  
  def prepare_lists
    @activity_categories = ActivityCategory.all
    @cities = City.all
    @branches = []
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
