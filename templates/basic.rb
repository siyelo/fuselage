
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