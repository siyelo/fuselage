gem_with_version "whenever", :lib => false, :source => 'http://gemcutter.org/'

log("Installing Whenever gem using sudo")

# install here (required since binary needed below)
rake "gems:install GEM=whenever"

run "wheneverize ."
