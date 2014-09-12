# -*- coding: utf-8 -*-
require File.expand_path('../boot', __FILE__)
# require 'csv'
require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

GIT_HEAD = "_#{`git rev-parse HEAD` [/(\w{7})/]}"
MEMCACHE_SERVERS = {"development"=>'localhost:11211',
                    "staging"=>'localhost:11211',
                    "test"=>'localhost:11211',
                    "production"=>'localhost:11211'}
module Resala
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{Rails.root}/lib #{Rails.root.to_s}/app/sweepers)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Africa/Cairo'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ar

    # JavaScript files you want as :defaults (application.js is always included).
    config.action_view.javascript_expansions[:defaults] = %w(https://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
    config.after_initialize do
      WillPaginate::ViewHelpers.pagination_options[:previous_label] = "السابق"       
      WillPaginate::ViewHelpers.pagination_options[:next_label] = "التالي"
    end
    
    config.cache_store = :mem_cache_store, MEMCACHE_SERVERS[Rails.env], { :namespace => "g#{GIT_HEAD}" }
  end
end
