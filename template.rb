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
  ENV['_APP_URL']         = "#{ENV['_APP_SUBDOMAIN']}.#{ENV['_APP_DOMAIN']}"
  ENV['_APP_ORG']         = ENV['ORGANIZATION'] || "Siyelo"
  ENV['_APP_DESCR']       = ENV['DESCRIPTION'] || 'This is a cool app'
  ENV['_APP_EMAILS']      = ENV['EMAIL_LIST'] || "support@#{ENV['_APP_DOMAIN']}"
  skip_gems               = ENV['SKIP_GEMS'].nil?

  gem_source_warning

  # Enforce this good practice if you're using github.
  log_header "Get github user"
  github_user = get_github_user

  #note 'git' is not included in the template list as its explicitly called later, after unpacking/vendoring
  templates = %w[ basic
                  app_layouts
                  jquery
                  google_analytics
                  capistrano
                  haml_sass_compass_blueprint
                  make_resourceful
                  will_paginate
                  cucumber_rspec_rpec-rails_webrat
                  watchr
                  exception_notification
                  action_mailer
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

  templates.each do |t|
    log_header "#{t.capitalize}"
    load_sub_template t  
  end

  log_header "DB Migrate"
  %w[development test].each do |env|
    run "rake db:migrate RAILS_ENV=#{env}"
  end

  if !use_heroku
    log_header "A freeze is coming!"
    rake 'rails:freeze:gems'

    log_header "Vendoring gems"
    rake "gems:unpack:dependencies"
    rake "gems:unpack:dependencies RAILS_ENV=test"
  end
  
  log_header "Convert all .erb to .haml"
  erb_to_haml
  
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

      # Success!
      log "SUCCESS! Your app is running at http://#{ENV['_APP_URL']}"
    end
  end

  unless skip_gems
    log_header "Install gems locally (as sudo)"
    log("  set SKIP_GEMS if you do not want to install gems via sudo")
    # Make sure all these gems are actually installed locally
    run "sudo rake gems:install"
    run "sudo rake gems:install RAILS_ENV=test"
  end

end

run_template unless ENV['TEST_MODE'] # hold off running the template whilst in unit testing mode