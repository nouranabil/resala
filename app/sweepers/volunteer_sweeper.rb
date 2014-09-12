class VolunteerSweeper < Sweeper
  observe Volunteer
  
  def after_update(volunteer)
    expire_action_cache_for("volunteers", "show", volunteer.id) if volunteer.changed?
    if first_volunteers_page(volunteer).collect{|t| t.id}.include?(volunteer.id)
      expire_action_cache_for("volunteers", "index", nil,  1)
    end
  end
  
  def after_create(volunteer)
    expire_action_cache_for("volunteers", "index", nil,  first_volunteers_page(volunteer).total_pages)
  end
  
  def after_destroy(volunteer)
    expire_action_cache_for("volunteers", "index", nil,  first_volunteers_page(volunteer).total_pages)
  end
  
  #######
  private
  #######
  
  def first_volunteers_page(volunteer)
    @volunteers || @volunteers =  Volunteer.latest.paginate(:page => 1, :per_page=>Volunteer.per_page)
  end
end