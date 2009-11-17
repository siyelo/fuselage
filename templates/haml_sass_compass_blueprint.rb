# Compass + blueprint installer
# by Glenn Roberts
# based on
# Compass Ruby on Rails Installer (template) v.1.0
# written by Derek Perez (derek@derekperez.com)
# Source : http://github.com/chriseppstein/compass/raw/master/lib/compass/app_integration/rails/templates/compass-install-rails.rb
# -----------------------------------------------------------------
# NOTE: This installer is designed to work as a Rails template,
# and can only be used with Rails 2.3+.
# -----------------------------------------------------------------

# css framework prompt
log("You have chosen 'blueprint' as a CSS framework")
css_framework = "blueprint"

# sass storage prompt
log("Your sass files will be stored in 'app/stylesheets'")
sass_dir = "app/stylesheets"

# compiled css storage prompt
log("Compass will store your compiled css files in 'public/stylesheets/compiled'")
css_dir = "public/stylesheets/compiled"

unless ENV['SKIP_GEMS']
  # define dependencies
  gem_with_version "haml", :lib => "haml", :version => ">=2.2.0"
  gem_with_version "chriseppstein-compass", :source => "http://gems.github.com/", :lib => "compass"

  # install
  rake "gems:install GEM=haml" #, :sudo => true
  log("Installing compass gem using sudo")
  rake("gems:install GEM=chriseppstein-compass", :sudo => true)

end

# build out compass command
compass_command = "compass --rails -f #{css_framework} . --css-dir=#{css_dir} --sass-dir=#{sass_dir} "

# Require compass during plugin loading
file 'vendor/plugins/compass/init.rb', <<-CODE
# This is here to make sure that the right version of sass gets loaded (haml 2.2) by the compass requires.
require 'compass'
CODE

# integrate it!
run "haml --rails ."
run compass_command

puts "Compass (with #{css_framework}) is all setup, have fun!"