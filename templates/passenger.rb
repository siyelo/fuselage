gem_with_version 'passenger'

rake "gems:install GEM=passenger", :sudo => true

log %q{ 
  WARN: Passenger requires a native build on first installation. You must do this manually.
  
  E.g. for an OSX-specific install;
  
  1. sudo passenger-install-apache2-module
  
  2. Be sure to follow the prescribed instructions from mod_rails adding the following to your httpd.conf. BE SURE TO USE THE SETTINGS DUMPED OUT WHEN YOU RUN passenger-install-apache2-module as the paths on your system may differ.  
  
  3. Restart Web Sharing via System pref pane or do a "sudo apachectl restart" if you are using your own Apache build
}