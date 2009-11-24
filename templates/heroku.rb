gem_with_version 'heroku',:env => 'development'

rake "gems:install GEM=heroku"

puts %q{
  Warning: be sure you have added your Heroku account email plus public key first using this command;
  
    $ heroku keys:add

}

if ENV['_USE_COMPASS']
  # stop Heroku complaining if you try to compile sass
  # Only compile them on development 
  file 'config/initializers/compass.rb', 
%q{ 
if Rails.env.to_sym == :development
  require 'compass'
  # If you have any compass plugins, require them here.
  Compass.configuration.parse(File.join(RAILS_ROOT, "config", "compass.config"))
  Compass.configuration.environment = RAILS_ENV.to_sym
  Compass.configure_sass_plugin!
end
}
  
end
