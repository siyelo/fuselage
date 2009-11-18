#ActionMailer SMTP setup.

initializer("mailer.rb", <<-EOS.gsub(/^  /, ''))
  # Load mail configuration if not in test environment
  env = ENV['RAILS_ENV'] || RAILS_ENV
  if env != 'test'
    mailer_options = YAML.load_file(RAILS_ROOT + '/config/mailer.yml')[env]
    ActionMailer::Base.smtp_settings = mailer_options unless mailer_options.nil?
  end
EOS

file("config/mailer.yml", <<-EOS.gsub(/^  /, ''))
  development:
    address: "mail.#{ENV['_APP_DOMAIN']}"
    port: 26
    domain: "www.#{ENV['_APP_DOMAIN']}"
    authentication: :login
    user_name: "noreply+#{ENV['_APP_DOMAIN']}"
    password: 'TODO: CHANGEME'
    tls: false
  test:
    address: "mail.#{ENV['_APP_DOMAIN']}"
    port: 26
    domain: "www.#{ENV['_APP_DOMAIN']}"
    authentication: :login
    user_name: "noreply+#{ENV['_APP_DOMAIN']}"
    password: 'TODO: CHANGEME'
    tls: false
  production:
    address: "mail.#{ENV['_APP_DOMAIN']}"
    port: 26
    domain: "www.#{ENV['_APP_DOMAIN']}"
    authentication: :login
    user_name: "noreply+#{ENV['_APP_DOMAIN']}"
    password: 'TODO: CHANGEME'
    tls: false  
EOS

##comment this out as we want to set up SMTP with AM.
gsub_file("/config/environments/development.rb", /config.action_mailer.raise_delivery_errors = false/mi) do
  "#config.action_mailer.raise_delivery_errors = false"
end

append_file("/config/environments/development.rb", <<-EOS.gsub(/^  /, ''))

  ### ActionMailer Config
  #
  # A dummy setup for development - no deliveries, but logged
  
  # set delivery method to :smtp, :sendmail or :test (or :activerecord for ar-mailer)
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_charset = "utf-8"
  
EOS

append_file("/config/environments/production.rb", <<-EOS.gsub(/^  /, ''))

  ### ActionMailer Config
  #
  # Setup for production - deliveries, no errors raised

  # set delivery method to :smtp, :sendmail or :test (or :activerecord for ar-mailer)
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_charset = "utf-8"

EOS
