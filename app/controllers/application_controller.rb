class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  
  def set_cookie(key, val)
    # cookies["flash_#{key}"] = { :value => val, :expires => 1.second.from_now }
    cookies["flash_#{key}"] = { :value => val, :expires => 2.days.from_now.utc }
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    set_cookie("alert", exception.message)
    redirect_to root_path
  end
  
  
  #######
  private
  #######
  
  def current_user
    user_id = session[:user_id]
    @current_user ||= (User.where("id = #{user_id}").first) unless user_id.blank? 
  end
end
