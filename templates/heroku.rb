gem_with_version 'heroku',:env => 'development'

rake "gems:install GEM=heroku", :sudo => true

puts %q{
  Warning: be sure you have added your Heroku account email plus public key first using this command;
  
    $ heroku keys:add

}