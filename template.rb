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

  #note 'git' is not included in the template list as its explicitly called later, after unpacking/vendoring
  templates = %w[ basic
                  app_layouts
                  jquery
                  google_analytics
                  haml_sass_compass_blueprint
                  cucumber_rspec_rpec-rails_webrat
                  heroku
]

  log_header "Install List"
  templates.each { |t| puts "  #{t}" }
  
  use_heroku = templates.include?('heroku')
  use_slicehost = templates.include?('slicehost')
  #TODO: create slicehost template
  
  if use_heroku && use_slicehost
    puts <<-EOS.gsub(/^ /, '')
  
    You may only specifiy one deploy type i.e. Heroku *or* Slicehost
    EOS
    exit
  end  

  ### cache variables that that are used in templates
  #
  if templates.include?('mysql')
    ENV['_MYSQL_PASS']      ||= ENV['MYSQL_PASS'] || ask("MySQL root user password? :")
  end
  ENV['_USE_HEROKU']    = '1' if use_heroku
  ENV['_USE_SLICEHOST'] = '1' if use_slicehost
  
  ENV['_USE_COMPASS'] = '1' if ( templates.include?('haml_sass_compass_960') || templates.include?('haml_sass_compass_blueprint'))

  templates.each do |t|
    log_header "#{t.capitalize}"
    load_sub_template t  
  end

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
  if !use_heroku
    log_header "A freeze is coming!"
    rake 'rails:freeze:gems'

    log_header "Vendoring gems"
    rake "gems:unpack:dependencies"
    rake "gems:unpack:dependencies RAILS_ENV=test"
  end

  log_header "Git"
  load_sub_template 'git'
  
  # Deploy!
  if use_heroku
    log_header "Heroku"
    if yes?("Deploy to Heroku now?")
      heroku :create, ENV['_APP_SUBDOMAIN']
      git :push => "heroku master"
      heroku :rake, "db:migrate"
      heroku :open

      log "SUCCESS! Your app is running at http://#{ENV['_APP_URL']}"
    end
  end

  # Make sure all these gems are actually installed locally
  if skip_gems.nil?
    log_header "Install gems locally (as sudo)"
    log("  set SKIP_GEMS if you do not want to install gems via sudo")
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