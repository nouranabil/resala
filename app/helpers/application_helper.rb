module ApplicationHelper
  def is_selected(ctrl)
    return "selected" if ctrl == params[:controller] 
  end
  
  def fb_picture(fb_id)
    return "http://graph.facebook.com/#{fb_id}/picture"
  end
  
  def homepage?(params)
    return params[:controller] == 'pages' &&  params[:action] == 'show' && params[:id] == :home
  end
  
  def sortable(column, title = nil, additional_params = nil, url = nil, html_class = nil)  
    title ||= column.titleize  
    css_class = (column == params[:sort]) ? "current #{sort_direction}" : nil  
    select_class = (params[:sort] == column) ? "selected" : nil
    select_class = select_class.nil? && params[:sort].blank? && column == "created_at" ? "selected" : select_class
    direction = (column == params[:sort] && sort_direction == "desc") ? "asc" : "desc"  
    link_to title, "#{url}?sort=#{column}&direction=#{direction}#{additional_params}", {:class => "#{css_class} #{select_class} #{html_class}", :title=>title}  
  end
  
  def activity_status_class(activity)
    case activity.status
    when ActivitiesStatus.requested
      return "awaiting"
    when ActivitiesStatus.accepted
      return "published"
    when ActivitiesStatus.rejected
      return "rejected"
    when ActivitiesStatus.closed
      return "closed"
    when ActivitiesStatus.request_close
      return "closed"
    when ActivitiesStatus.request_cancel
      return "closed"
    when ActivitiesStatus.cancelled
      return "closed"
    end
  end
end
