# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem "sqlite3-ruby", :lib => "sqlite3"
  config.gem "haml", :version => "= 3.0.12"
  config.gem "compass", :version => "= 0.10.2"
  config.gem 'compass-960-plugin', :lib => 'ninesixty', :version => "= 0.9.13"
  config.gem "will_paginate"
  config.gem "formtastic"
  config.gem 'aasm'
  config.gem 'paperclip'
  #config.gem 'heroku_san'
  #config.gem 'rakeist'
  
  # inherited resources for Rails 2.3
  config.gem 'inherited_resources'
  config.gem 'responders'

  # configatron
  config.gem "yamler"
  config.gem "configatron"

  config.gem 'google_analytics', :lib => 'rubaidh/google_analytics'

  config.time_zone = 'UTC'

end