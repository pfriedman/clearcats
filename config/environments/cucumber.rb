# Edit at your own peril - it's recommended to regenerate this file
# in the future when you upgrade to a newer version of Cucumber.

# IMPORTANT: Setting config.cache_classes to false is known to
# break Cucumber's use_transactional_fixtures method.
# For more information see https://rspec.lighthouseapp.com/projects/16211/tickets/165
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

config.gem 'cucumber-rails',   :lib => false, :version => '>=0.3.2' unless File.directory?(File.join(Rails.root, 'vendor/plugins/cucumber-rails'))
config.gem 'database_cleaner', :lib => false, :version => '>=0.5.0' unless File.directory?(File.join(Rails.root, 'vendor/plugins/database_cleaner'))
config.gem 'capybara',         :lib => false, :version => '>=0.3.5' unless File.directory?(File.join(Rails.root, 'vendor/plugins/capybara'))

config.after_initialize do
  # Bcsec.configure do
  #   ui_mode :cas
  #   api_mode :cas_proxy
  #   authorities :cas, :pers
  #   pers_parameters :separate_connection => true
  #   central '/etc/nubic/bcsec-local.yml'
  # end

  # Bcsec.configure do
  #   login_config = File.join(RAILS_ROOT, %w(config logins development.yml))
  # 
  #   authority Bcsec::Authorities::Static.from_file(login_config)
  # end
  
  # look at db/user-setup.sql for user and group security settings when developing in a local environment
  Bcsec.configure do
    ui_mode :form
    authorities :pers
    central '/etc/nubic/bcsec-local.yml'
  end
  
  PaperTrail.enabled = true
end