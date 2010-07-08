# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_clearcats_session',
  :secret      => '8fbe8a94dde91831eb323b5a4a467f5f51364cf078e15c613baf48452271ed0ec4203f901b6716ebef0fcfceb2076c48d65896760ac689d1d63aece1db15ccf9'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
