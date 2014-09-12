require 'resque/tasks'
require 'resque_scheduler/tasks'    

task "resque:setup" => :environment do
  I18n.locale = 'ar'
  require 'resque'
  require 'resque_scheduler'
  require 'resque/scheduler'
  
  Resque.after_fork do |job|
    ActiveRecord::Base.establish_connection
  end

  # If you want to be able to dynamically change the schedule,
  # uncomment this line.  A dynamic schedule can be updated via the
  # Resque::Scheduler.set_schedule (and remove_schedule) methods.
  # When dynamic is set to true, the scheduler process looks for 
  # schedule changes and applies them on the fly.
  # Note: This feature is only available in >=2.0.0.
  Resque::Scheduler.dynamic = true

  # The schedule doesn't need to be stored in a YAML, it just needs to
  # be a hash.  YAML is usually the easiest.
  #Resque.schedule = YAML.load_file('your_resque_schedule.yml')
end