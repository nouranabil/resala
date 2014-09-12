class Ability
  include CanCan::Ability

  def initialize(user)
    can [:index], Volunteer
    can [:index], Activity
    can :gateway, Volunteer
    can [:show, :volunteers], Activity do |a|
      a.status == ActivitiesStatus.accepted || a.finished?
    end
        
    if user
      case user.type
      when 'Admin'
        can :manage, :all
        cannot [:request_activities_authority, :activities_authority], Volunteer
        cannot :join_activity, Activity
        cannot :quit, Activity
        cannot [:edit, :update], Volunteer
        cannot [:edit, :update], Admin
        cannot [:close,:publish,:reject,:announce], Activity
        can :close, Activity do |activity|
          activity.pending_finished?
        end
        can :publish, Activity do |activity|
          activity.status == ActivitiesStatus.requested || activity.status == ActivitiesStatus.rejected
        end
        can :announce, Activity do |activity|
          activity.status == ActivitiesStatus.accepted
        end
        can :reject, Activity do |activity|
          activity.status == ActivitiesStatus.requested || activity.status == ActivitiesStatus.accepted
        end
        cannot :destroy, Branch do |branch|
          (branch.alternative_branch.nil? ||(branch.alternative_branch == branch))  && (branch.volunteers.length != 0 || branch.activities.length != 0)  
        end
        cannot :destroy, ActivityCategory do |ac|
          ac.branches.length != 0 || ac.activities.length != 0 
        end
        cannot :activate, User do |u|
           !(u.type.nil?)
        end
      when 'Volunteer'
        can [:edit, :update, :activities, :activity, :dashboard, :previous_activities, :upcoming_activities], Volunteer do |v|
          user.id == v.id
        end
        if HIDE_ACTIVITY_CLOSING
          cannot :previous_activities, Volunteer
        end
        can :show, Volunteer do |v|
          user.id == v.id || user.activities_authority_status == ActivitiesAuthorityStatus.accepted
        end
        can :volunteer_details, Volunteer do |v|
	        user.activities_authority_status == ActivitiesAuthorityStatus.accepted
        end
        
        can [:request_activities_authority, :activities_authority], Volunteer do 
          user.activities_authority_status.to_i < ActivitiesAuthorityStatus.requested.to_i
        end
        can [:new, :create], Activity do
          user.activities_authority_status == ActivitiesAuthorityStatus.accepted
        end
        can [:edit, :update, :request_close], Activity do |a|
          a.user_id == user.id && ! a.finished? 
        end
        if HIDE_ACTIVITY_CLOSING
          cannot :request_close, Activity
        end
        can [:preview], Activity do |a|
          a.user_id == user.id && !HIDE_ACTIVITY_CLOSING
        end
        can :show, Activity do |a|
          a.status == ActivitiesStatus.accepted || (a.finished? && !a.cancelled?)  || a.user_id == user.id
          if a.status == ActivitiesStatus.accepted && a.user_id == user.id && !HIDE_ACTIVITY_CLOSING
            can [:new, :create], Achievement
          end
        end
        can :volunteers, Activity do |a|
          a.status == ActivitiesStatus.accepted || a.finished? || a.user_id == user.id
          can :update_join_activity, Volunteer do |v|
            ar = ActivitiesRequest.where(:volunteer_id => v.id, :activity_id=> a.id).first;
            !(a.finished?) && !(ar.nil?)
          end
        end
        can :join_activity, Activity do |a|
          ar = user.activities_requests.where(:activity_id=>a.id).first
          a.status == ActivitiesStatus.accepted && !ar && a.user_id != user.id
        end
        can :quit, Activity do |a|
          # user must be already volunteered , not the owner and activity is not closed/cancelled or requested to be closed/cancelled
          ar = user.activities_requests.where(:activity_id=>a.id).first
          !(a.finished?) && !(ar.nil?) && a.user_id != user.id
        end
      end
    else
      can [:new, :create], Volunteer
    end
  end
end
