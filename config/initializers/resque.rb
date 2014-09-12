require 'resque/failure/notifier'
require 'resque/failure/multiple'
require 'resque/failure/redis'

Dir[File.join(Rails.root, 'lib', '*.rb')].each { |file| require file}
resque_config = YAML.load_file("#{Rails.root.to_s}/config/redis.yml")
Resque.redis = resque_config[Rails.env]

Resque::Failure::Multiple.classes = [Resque::Failure::Redis,Resque::Failure::Notifier]
Resque::Failure.backend = Resque::Failure::Multiple

Resque::Failure::Notifier.configure do |config|
  config.sender = 'error@resala.org'
  config.recipients = Rails.env == 'production'  ? ['yaser.alashry@espace.com.eg','webmaster@resala.org'] : ['yaser.alashry@espace.com.eg']
end
