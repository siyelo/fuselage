log("Installing Whenever gem using sudo")

rake "gems:install GEM=whenever", :sudo => true, :lib => false, :source => 'http://gemcutter.org/'

run "wheneverize ."
