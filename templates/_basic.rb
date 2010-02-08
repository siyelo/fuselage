### Basic goodies
# Delete unnecessary files
run "rm README"
run "rm public/index.html"
run "rm public/favicon.ico"
run "rm public/images/rails.png"
run "rm -rf test"
file "README.md", ""

file "public/robots.txt", <<-EOS.gsub(/^  /, '')
User-agent: *
Disallow: /
EOS

log "Modifying /config/environment.rb"
gsub_file('/config/environment.rb', /# Be sure to restart your server when you modify this file/mi) do 
  <<-EOS.gsub(/^  /, '')
  # Be sure to restart your server when you modify this file

  APP_NAME         = "#{ENV['_APP']}"
  APP_SUBDOMAIN    = "#{ENV['_APP_SUBDOMAIN']}"
  APP_DOMAIN       = "#{ENV['_APP_DOMAIN']}"
  APP_DATABASE     = "#{ENV['_APP_DB']}"
  APP_DESCRIPTION  = "#{ENV['_APP_DESCR']}"
  APP_URL          = "#{ENV['_APP_URL']}"
  APP_ORGANIZATION = "#{ENV['_APP_ORG']}"

  throw "The project's name in environment.rb is blank" if APP_NAME.empty?
  throw "Project db name (\#{APP_DATABASE}) must_be_like_this" unless APP_DATABASE =~ /^[a-z_]*$/
EOS
end