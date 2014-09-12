class BranchSweeper < Sweeper
  observe Branch
  
  def after_update(branch)
    expire_action_cache_for("branches", "show", branch.id) if branch.changed?
    expire_action_cache_for("branches", "index", nil,  branch.city_id)
  end
  
  def after_create(branch)
    expire_action_cache_for("branches", "index")
  end
  
  def after_destroy(branch)
    expire_action_cache_for("branches", "index")
  end
  
  #######
  private
  #######
  
  def expire_action_cache_for(obj_controller, obj_action, obj_id = nil, city_id = 0, format = :js)
    if obj_id
      expire_action(:controller => "/#{obj_controller}", :action => obj_action, :id => obj_id)
      expire_action(:controller => "/#{obj_controller}", :action => obj_action, :id => obj_id, :format=>format)
    else
      expire_action(:controller=>"/#{obj_controller}", :action=>obj_action, :city_id=>city_id)
      expire_action(:controller=>"/#{obj_controller}", :action=>obj_action, :city_id=>city_id, :format=>format)
    end
  end
end