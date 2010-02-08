# Set up .gitignore files
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
run %{find . -type d -empty | grep -v "vendor" | grep -v ".git" | grep -v "tmp" | xargs -I xxx touch xxx/.gitignore}
file '.gitignore', <<-EOS.gsub(/^  /, '')
.DS_Store
log/*.log
tmp/**/*
config/database.yml
config/initializers/site_keys.rb
db/*.sqlite3
EOS

# Set up git repository
git :init
git :add => '.'
git :commit => "-a -m 'Initial project commit'"