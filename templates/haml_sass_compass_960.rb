# Compass + 960 installer
# by Glenn Roberts
# based on
# Compass Ruby on Rails Installer (template) v.1.0
# written by Derek Perez (derek@derekperez.com)
# Source : http://github.com/chriseppstein/compass/raw/master/lib/compass/app_integration/rails/templates/compass-install-rails.rb
# -----------------------------------------------------------------
# NOTE: This installer is designed to work as a Rails template,
# and can only be used with Rails 2.3+.
# -----------------------------------------------------------------


# Note it requires the following in your app layout - done automatically if you use app_layouts.rb
#  = stylesheet_link_tag 'compiled/screen.css', :media => 'screen, projection'
#  = stylesheet_link_tag 'compiled/print.css', :media => 'print'
#  /[if IE]
#    = stylesheet_link_tag 'compiled/ie.css', :media => 'screen, projection'



# css framework prompt
log("You have chosen '960' as a CSS framework")
css_framework = "960"

# sass storage prompt
log("Your sass files will be stored in 'app/stylesheets'")
sass_dir = "app/stylesheets"

# compiled css storage prompt
log("Compass will store your compiled css files in 'public/stylesheets/compiled'")
css_dir = "public/stylesheets/compiled"

# define dependencies
gem_with_version "haml", :lib => "haml", :version => ">=2.2.0"
gem_with_version "chriseppstein-compass", :source => "http://gems.github.com/", :lib => "compass"
gem_with_version "chriseppstein-compass-960-plugin", :source => "http://gems.github.com", :lib => "ninesixty"

# install here (required since binaries needed below)
rake "gems:install GEM=haml"
rake "gems:install GEM=chriseppstein-compass"
rake "gems:install GEM=chriseppstein-compass-960-plugin" 

css_framework = "960" # rename for command
plugin_require = "-r ninesixty"

# build out compass command
compass_command = "compass --rails -f #{css_framework} . --css-dir=#{css_dir} --sass-dir=#{sass_dir} "
compass_command << plugin_require if plugin_require

# Require compass during plugin loading
file 'vendor/plugins/compass/init.rb', <<-CODE
# This is here to make sure that the right version of sass gets loaded (haml 2.2) by the compass requires.
require 'compass'
CODE

# integrate it!
run "haml --rails ."
run compass_command

puts "Compass (with #{css_framework}) is all setup, have fun!"