# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

config.after_initialize do
  # uncomment the following if you'd like to use the static file for login information
  # Bcsec.configure do
  #   login_config = File.join(RAILS_ROOT, %w(config logins development.yml))
  #   authority Bcsec::Authorities::Static.from_file(login_config)
  # end
  
  # look at db/user-setup.sql for user and group security settings when developing in a local environment
  Bcsec.configure do
    ui_mode :form
    authorities :pers
    central '/etc/nubic/bcsec-local.yml'
  end

  #Comment out the previous call to Bcsec.configure and uncomment the following
  #if you want to develop against a local CAS server.
  # Bcsec.configure do
  #   ui_mode :cas
  #   api_mode :cas_proxy
  #   authorities :cas, :pers
  #   central '/etc/nubic/bcsec-local.yml'
  # end

  PaperTrail.enabled = true
end