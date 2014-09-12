Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, OMNIAUTH_CONFIG[:facebook]["key"], OMNIAUTH_CONFIG[:facebook]["secret"],
           :scope => OMNIAUTH_CONFIG[:facebook]["scope"]
end