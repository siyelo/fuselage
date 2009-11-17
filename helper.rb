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
#   stolen from Dr Nic: Mocra template : http://github.com/drnic/rails-templates

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

  dev_env  = options[:env] == 'development' ? true : false #gem() seems to wipe this param out.
  test_env = options[:env] == 'test' ? true : false #gem() seems to wipe this param out.
  
  if gem_spec = Gem.source_index.find_name(name).last
    version = gem_spec.version.to_s
    options = {:version => ">= #{version}"}.merge(options)
  else
    $stderr.puts "  WARN: cannot find gem #{name} in repo - cannot load version. Adding it anyway."
  end
 
  gem(name, options) unless ENV['SKIP_GEMS']
  
  # optionally install production gems on Heroku
  if ENV['_USE_HEROKU'] && !(test_env) && !(dev_env)
    file ".gems", "" unless File.exists?(".gems")
    version_str = options[:version] ? "--version '#{options[:version]}'" : ""
    source_str  = options[:source]  ? "--source '#{options[:source]}'" : ""
    puts "Appending gem #{name} to .gems"
    append_file '.gems', "#{name} #{version_str} #{source_str}\n"
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

def heroku(cmd, arguments="")
  run "heroku #{cmd} #{arguments}"
end