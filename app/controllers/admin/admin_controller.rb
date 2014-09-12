class Admin::AdminController < ApplicationController
  layout 'admin'
  before_filter :require_admin
  
  #######
  private
  #######
  
  def require_admin
    if current_user && current_user.admin?
      return true unless current_user.email.blank? || !(current_user.mobile =~ /^01[0-9]{9}$/)
      redirect_to admin_data_entry_path
      return false
    elsif current_user && current_user.type.nil?
      redirect_to admin_data_entry_path
      return false
    elsif !current_user
      redirect_to "/admin_login/facebook"
      return false 
    else
      redirect_to root_path
      return false
    end
  end
end