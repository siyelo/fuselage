# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_CHANGEME_session',
  :secret      => '946a27689abf0572ef3963327bd4a77daffdf87cd8e9ed9d1bcc735b8aa757d78dc571b3b3393dcdbe7d1c5ae76a4e0bf92b0e5e27b447b9cbb7b81cd538ea7a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
