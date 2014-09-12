class Admin::AdminsController < Admin::AdminController
  load_and_authorize_resource :user
  before_filter :load_users
  helper_method :sort_column, :sort_direction
  
  def index
  end
  
  def activate
    @user = User.find params[:id]
    @user.type = 'Admin'
    if @user.save
      flash[:notice] = t('messages.admin_activated')
    else
      flash[:alert] = t('messages.admin_not_activated')
    end
    render :action => :index
  end
  
  #######
  private
  #######
  
  def load_users
    @users = User.where("type = 'Admin' OR type IS NULL").order(sort_column + ' ' + sort_direction)
  end
  
  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end  
    
  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "desc"
  end
end
