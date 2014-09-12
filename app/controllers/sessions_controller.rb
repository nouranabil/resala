class SessionsController < ApplicationController
  before_filter :store_return_to, :only => [:destroy, :admin_login, :login, :volunteering]
  
  def create
    auth = request.env["omniauth.auth"]
    cookies[:friend_ids] = ""
    
    if request.env["omniauth.origin"] == "admin_login"
      user = Admin.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_admin_with_omniauth(auth)
      
      # update token
      user.provider_token = auth["credentials"]["token"]
      user.provider_secret = auth["credentials"]["secret"]
      user.save
      
      # Mostafa  # storing the user_id in cookies because we had a bug, the session data is not reachable in the delete request.
      session[:user_id] = user.id
      
      redirect_to "/admin"
      
    else
      @volunteer = Volunteer.initialize_volunteer_with_omniauth(auth)
      # update token
      
      @volunteer.provider_token = auth["credentials"]["token"]
      @volunteer.provider_secret = auth["credentials"]["secret"]
      @volunteer.save unless @volunteer.id.blank?
      @return_to_url = root_url
      
      if request.env["omniauth.origin"] == "volunteering" && !@volunteer.new_record? #done
        session[:user_id] = @volunteer.id
        set_cookie("notice", t("messages.already_volunteered"))
        #redirect_to "/"
      elsif @volunteer.new_record?
        session[:auth]= {:provider => @volunteer.provider,
                         :uid => @volunteer.uid,
                         :provider_token => @volunteer.provider_token,
                         :image => @volunteer.image,
                         :provider_secret => @volunteer.provider_secret,
                         :name => @volunteer.name,
                         :email => @volunteer.email,
                         :gender => @volunteer.gender
                        }
        if request.env["omniauth.origin"] != "volunteering"
          set_cookie("alert", t("messages.not_volunteered"))
        end
        @return_to_url = new_volunteer_path
      elsif @volunteer.suspended #done
        set_cookie("alert", t("messages.account_suspended"))
        @return_to_url = return_to_url
      else
        session[:user_id] = @volunteer.id #done
        set_cookie("notice", t("messages.logged_in"))
        @return_to_url = return_to_url
        #redirect_to_return
      end
      render :layout => false
    end
  end
  
  def new
    @volunteer = Volunteer.new(session[:auth])
    @activity_categories = ActivityCategory.all
    @cities = City.all
    #@branches = @volunteer.branch ? @volunteer.branch.city.branches : []
    @branches = Branch.branches_list    
  end
  
  def destroy
    unless session[:user_id].blank?
      session[:user_id] = nil
    end
    
    if cookies[:return_to].match(/\/admin/)
      cookies[:return_to] = "/"
    end
    
    cookies[:friend_ids] = ""
    redirect_to_return
  end
  
  def admin_login
    redirect_to "/auth/#{params[:provider]}?origin=admin_login"
  end
  
  def login
    cookies[:action_after_login] = params[:action_after_login] unless params[:action_after_login].blank?
    redirect_to "/auth/#{params[:provider]}?origin=volunteer_login"
  end
  
  def volunteering
    redirect_to "/auth/#{params[:provider]}?origin=volunteering"
  end
  
  def failure
    set_cookie("alert", t("messages.login_failed"))
    @return_to_url = return_to_url
    render :action=> :create, :layout => false
  end
  
  #######
  private
  #######
  
  def store_return_to
    cookies[:return_to] = request.env["HTTP_REFERER"] || "/"
    cookies[:action_after_login] = nil
  end
  
  def return_to_url
    return_to_path = cookies[:action_after_login].blank? ? cookies[:return_to] : cookies[:action_after_login]
    cookies[:return_to] = nil
    return return_to_path
  end
  
  def redirect_to_return
    return_to_path = cookies[:action_after_login].blank? ? cookies[:return_to] : cookies[:action_after_login]
    cookies[:return_to] = nil
    redirect_to return_to_path
  end
end