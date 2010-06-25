RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')
require 'yaml'

config_file_path = File.join(RAILS_ROOT, *%w(config settings.yml))
if File.exist?(config_file_path)
  config = YAML.load_file(config_file_path)
  APP_CONFIG = config.has_key?(RAILS_ENV) ? config[RAILS_ENV] : {}
else
  puts "WARNING: configuration file #{config_file_path} not found."
  APP_CONFIG = {}
end

Rails::Initializer.run do |config|
  config.gem "sqlite3-ruby", :lib => "sqlite3"
  config.gem "haml", :version => "= 3.0.12"
  config.gem "compass", :version => "= 0.10.2"
  config.gem 'compass-960-plugin', :lib => 'ninesixty', :version => "= 0.9.13"
  config.gem "will_paginate"
  config.gem "formtastic"
  config.gem 'aasm'
  config.gem 'paperclip'
  config.gem 'google_analytics', :lib => 'rubaidh/google_analytics'
  #config.gem 'heroku_san'
  #config.gem 'rakeist'

  # inherited resources for Rails 2.3
  #config.gem 'inherited_resources'
  #config.gem 'responders'

  config.time_zone = 'UTC'

  DEFAULT_KEY = '_yourapp_session'
  DEFAULT_SECRET = "20df89ac2c023846bca3e8dfc0abaf0de58867e17516eb94431ec94ee086e2c0d8e88738218f577bd94e8438ee61b2fea9a47f456ce021cbe74c155b07b79c8a"
  key = APP_CONFIG[:action_controller][:session][:key] rescue DEFAULT_KEY
  secret = APP_CONFIG[:action_controller][:session][:secret] rescue DEFAULT_SECRET
  config.action_controller.session = { :key => key, :secret => secret }

end