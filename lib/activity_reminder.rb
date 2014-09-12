class ActivityReminder
  @queue = 'mailer'
  def self.perform(activity_id)
    activity = Activity.find(activity_id);
    activity.remind_volunteers!
  end
end