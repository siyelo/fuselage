# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_test-app_session',
  :secret      => '72720662732f08ad7810cd537220b0a75ee6e4b4d83e6dca2c9cbca24c0d4afe95fc7851432d57a6c8d9c0293f07b37af3bc61d7dc1a9977999d11d00464de2d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
