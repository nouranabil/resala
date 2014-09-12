desc "Notify volunteers of upcoming activities"
task "notify_volunteers" => :environment do
  I18n.locale = 'ar'
  # notify interested volunteers about newly published activities
  done = false
  limit = 100
  while !done do
    @volunteers = Volunteer.with_pending_notifications.select('id,email,name,pending_notifications,has_pending_notifications').limit(limit)
    if @volunteers.to_a.empty?
      done = true
    else
      @volunteers.each do |v|
        ac_ids = (v.pending_notifications || "").split(" ").uniq
        upcoming_ids = Activity.where(:id => ac_ids.join(',')).where( "start_date >= '#{Date.today.to_s}'").select("id").collect(&:id)
        if !upcoming_ids.empty?
          puts "sending email to #{v.name} to notify about activities #{upcoming_ids}"
          Mailer.upcoming_activities_volunteer_notification(v.id, upcoming_ids).deliver
        end
        #v.has_pending_notifications = false
        v.update_attribute('has_pending_notifications' , false)
        v.update_attribute('pending_notifications' , "")
        #v.save!
      end      
    end
   end
end
