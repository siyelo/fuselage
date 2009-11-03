### Set up environment
#

#def fuselage_dir
#  if !ENV['FUSELAGE_DIR']
#    "#{root}/../fuselage"
#  else
#    ENV['FUSELAGE_DIR']
#  end
#end

def templates_dir
  "#{fuselage_dir}/templates"
end

def assets_dir
  "#{fuselage_dir}/assets"
end

### Helpers
#

def template(&block)
  @store_template = block
end

def run_template
  @store_template.call
end

def load_sub_template(t) 
  load_template "#{templates_dir}/#{t}.rb"
end

def get_github_user
  github_user = run("git config --get github.user").strip
  if github_user.blank?
    puts <<-EOS.gsub(/^    /, '')
    You need to install your github username and API token.
  
    * Go to http://github.com/account
    * Click "Global Git Config"
    * Execute the two lines displayed
    * Run "git config --list" to check that github.user and github.token are installed
    EOS
    exit
  end
end

def gem_with_version(name, options = {})
  if gem_spec = Gem.source_index.find_name(name).last
    version = gem_spec.version.to_s
    options = {:version => ">= #{version}"}.merge(options)
    gem(name, options)
  else
    $stderr.puts "  WARN: cannot find gem #{name} in repo - cannot load version. Adding it anyway."
    gem(name, options)
  end
  options
end

def gem_source_warning
  puts <<-EOS.gsub(/^ /, '')
  
  Be sure your gem sources are up to date:
    gem sources -a http://gemcutter.org/
    gem sources -a http://gems.github.com  
  
  EOS
end

def log_header(header)
  print "\n  #{header}\n  "
  header.length.times {print "="}
  puts
end