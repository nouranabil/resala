class PagesController < ApplicationController
  caches_action :show, :layout=>true, :expires_in=>1.hours.to_i, :if=>Proc.new{params[:id] == :home}
  before_filter :require_nil_type_user, :only=> [:admin_data_entry,:update_admin_info]
  
  def show
    if params[:id] == :home
      @news = Article.news.latest.limit(5)
      @activities = Activity.published.upcoming.latest.limit(5)
      @per_page = 6;
      @slider_activities = ActivityCategory.latest
      @query = Media.construct_query(:media_type=>'photos',:page=>1,:per_page=>@per_page)
    end
      
    render :template => "pages/#{params[:id].to_s.downcase}"
  end
  
  def user_info
  end
  
  def admin_data_entry
    @user = current_user
  end
  
  def update_admin_data
    @user = current_user
    @user.type = 'temp' if @user.type.blank?
    @user.attributes = params[:user]
    if @user.valid?
      @user.type = nil if @user.type == "temp"  
      @user.save!
      if @user.admin?
        flash[:notice]= t("messages.saved", :name => t("user.your_data"))
        redirect_to("/admin")
      else
        set_cookie("notice", t("messages.saved", :name => t("user.your_data")))
        redirect_to("/")
      end
    else
      set_cookie("alert", t("messages.failed"))
      render :action => "admin_data_entry"
    end
  end
  
  #######
  private
  #######
  
  def require_nil_type_user
    unless current_user && (current_user.type.nil? || current_user.admin?) 
      redirect_to "/"
      return false
    end
  end
  
end