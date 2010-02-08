def fuselage_dir
  if !ENV['FUSELAGE_DIR']
     File.expand_path("#{root}/../fuselage")
  else
    ENV['FUSELAGE_DIR']
  end
end

if !File.exist?("#{fuselage_dir}/template.rb")
  inside('../') do
    log("Fetching Fuselage from github")
    log("  Fuselage will be installed to #{fuselage_dir}")
    run "git clone git://github.com/siyelo/fuselage.git"
    run "rm -rf fuselage/.git"
    ENV['_GITHUB_FETCHED'] = '1'
  end
end

# Load the template helpers
load_template "#{fuselage_dir}/helper.rb"

template do
  log_header "Siyelo Fuselage - Rails Templates"

  app_name                = File.basename(root)
  ENV['_APP']             = app_name.gsub(/[_-]/, ' ').titleize
  ENV['_APP_SUBDOMAIN']   = app_name.gsub(/[_\s]/, '-').downcase
  ENV['_APP_DB']          = app_name.gsub(/[-\s]/, '_').downcase
  ENV['_APP_DOMAIN']      = ENV['DOMAIN'] || 'siyelo.com'
  ENV['_APP_URL']         = "http://#{ENV['_APP_SUBDOMAIN']}.#{ENV['_APP_DOMAIN']}"
  ENV['_APP_ORG']         = ENV['ORGANIZATION'] || "Siyelo"
  ENV['_APP_DESCR']       = ENV['DESCRIPTION'] || 'This is a cool app'
  ENV['_APP_EMAILS']      = ENV['EMAIL_LIST'] || "support@#{ENV['_APP_DOMAIN']}"
  skip_gems               = ENV['SKIP_GEMS']

  gem_source_warning

  # Enforce this good practice if you're using github.
  log_header "Get github user"
  github_user = get_github_user

  #note files prefixed with underscore '_' are excluded. these should be loaded manually
  templates = Dir.glob(File.join("templates/", "*.rb")).reject { |f| File.basename(f).match(/^_/)  }  
  
  ### cache variables that that are used in templates
  #
  if templates.include?('mysql')
    ENV['_MYSQL_PASS']      ||= ENV['MYSQL_PASS'] || ask("MySQL root user password? :")
  end
  
  log_header "Basic preparation"
  load_sub_template '_basic'
    
  templates.each do |t|
    if yes?("Do you want to install #{File.basename(t) ?: }")
      log_header "#{t.capitalize}"
      load_sub_template t
    end
  end
  
  log_header "Finishing up..."

  log_header "DB Migrate"
  %w[development test].each do |env|
    run "rake db:migrate RAILS_ENV=#{env}"
  end
  
  log_header "Convert all .erb to .haml"
  erb_to_haml  #warning - dont do this after vendoring ! :-)
  
  # generate compiled stylesheeets
  if ENV['_USE_COMPASS']
    log_header "Compass generate css "
    run "compass" 
  end
  
  #Freeze & Vendor
  if yes?("Do you want to freeze & vendor the gems?")
    log_header "A freeze is coming!"
    rake 'rails:freeze:gems'

    log_header "Vendoring gems"
    rake "gems:unpack:dependencies"
    rake "gems:unpack:dependencies RAILS_ENV=test"
  end

  log_header "Git"
  load_sub_template '_git'
  
  # Deploy!
  log_header "Heroku"
  if yes?("Deploy to Heroku now?")
      heroku :create, ENV['_APP_SUBDOMAIN']
      git :push => "heroku master"
      heroku :rake, "db:migrate"
      heroku :open

      log "SUCCESS! Your app is running at http://#{ENV['_APP_URL']}"
  end

  # Make sure all these gems are actually installed locally
  if skip_gems.nil?
    log("Note: set SKIP_GEMS if you want to skip this step")
    if yes?("Install gems locally (as sudo)?")
    run "sudo rake gems:install"
    run "sudo rake gems:install RAILS_ENV=test"
  end


  #cleanup
  if ENV['_GITHUB_FETCHED']
    inside('../') do
      log("Cleaning up Fuselage")
      run "rm -rf #{fuselage_dir}"
    end
  end
end

run_template unless ENV['TEST_MODE'] # hold off running the template whilst in unit testing mode