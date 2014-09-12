# Be sure to restart your server when you modify this file.

# Resala::Application.config.session_store :cookie_store, :key => '_resala_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Resala::Application.config.session_store :active_record_store



ActionController::Base.session = {
  :key    => '_resala_session',
  :session_key => '_resala_session',
  :secret => 'e1919cde596cd9af7d802f19792591cfa1771c8cd0298f44a7b659a847c065645b66084734f6cee11c9f212caf47ad6735caa360963fc19c719d4f82b78690dd'
}

require 'memcache'
CACHE = MemCache.new({
  :namespace => "a#{GIT_HEAD}"
})

CACHE.servers = MEMCACHE_SERVERS[Rails.env]
if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    if forked
      # We're in smart spawning mode.
      CACHE.reset
    end
  end
end

Resala::Application.config.session_store = :mem_cache_store
Resala::Application.config.session_options[:cache] = CACHE