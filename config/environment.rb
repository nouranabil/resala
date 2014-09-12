# Load the rails application
require File.expand_path('../application', __FILE__)

ip = (`/sbin/ifconfig eth0 | grep 'addr:' | awk {'print $2'} | awk -F ':' {'print $2'} 2>&1`).strip
SERVER_IP = ip.blank? ? 'localhost' : ip.strip

FACEBOOK_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/facebook.yml")[Rails.env].symbolize_keys
OMNIAUTH_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/omniauth.yml")[Rails.env].symbolize_keys
PAYMENT_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/payment.yml")[Rails.env].symbolize_keys
HIDE_ACTIVITY_CLOSING = false
FEEDBACK_EMAIL = 'espace.goegypt.dev@gmail.com'
#RESALA_PAGE = "http://www.facebook.com/Resala.org"
CACHE_EXPIRES_IN = Proc.new{12.hours.to_i}

# Initialize the rails application
Resala::Application.initialize!
