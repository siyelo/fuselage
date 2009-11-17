
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
  
  # Change this to the name of your rails project, like carbonrally.  
  # Just use the same name as the svn repo.
  PROJECT_NAME        = "#{ENV['_APP_DB']}"
  PROJECT_DESCRIPTION = "#{ENV['_DESCR']}"

  throw "The project's name in environment.rb is blank" if PROJECT_NAME.empty?
  throw "Project name (\#{PROJECT_NAME}) must_be_like_this" unless PROJECT_NAME =~ /^[a-z_]*$/
EOS
end
