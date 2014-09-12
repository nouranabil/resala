class Sweeper < ActionController::Caching::Sweeper
  
  #######
  private
  #######
  
  def expire_action_cache_for(obj_controller, obj_action, obj_id = nil, pages_count = nil)
    if obj_id
      expire_action(:controller => "/#{obj_controller}", :action => obj_action, :id => obj_id)
    else
      pages_count.to_i.times do |page_num|
        expire_action(:controller=>"/#{obj_controller}", :action=>obj_action, :page=>page_num+1)
      end
    end
  end
end