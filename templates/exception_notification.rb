plugin 'exception_notifier', :git => 'git://github.com/rails/exception_notification.git'

gsub_file("app/controllers/application_controller.rb", /class ApplicationController < ActionController::Base/mi) do
  "class ApplicationController < ActionController::Base\n  include ExceptionNotifiable"
end

recipients = ask(" Enter your exception notification recpients (space separated list) : ")
app = ENV['_APP']
app_url = ENV['_APP_URL']

file '/config/exception.yml', <<-EOS.gsub(/^  /, '')
  development:
    recipients: #{recipients}
    sender: '\"Application Error\" <dev.app.error@#{app_url}>'
    prefix: "[#{app} Devel] "
  test:
    recipients: #{recipients}
    sender: '\"Application Error\" <test.app.error@#{app_url}>'
    prefix: "[#{app} Test] "
  staging:
    recipients: #{recipients}
    sender: '\"Application Error\" <staging.app.error@#{app_url}>'
    prefix: "[#{app} Staging] "
  production:
    recipients: #{recipients}
    sender: '\"Application Error\" <prod.app.error@#{app_url}>'
    prefix: "[#{app}] "
EOS
  
file '/config/initializers/exception_notifier.rb', <<-EOS.gsub(/^  /, '')
  env = ENV['RAILS_ENV'] || RAILS_ENV
  EXCEPTION_NOTIFIER = YAML.load_file(RAILS_ROOT + '/config/exception.yml')[env]
  ExceptionNotifier.exception_recipients = EXCEPTION_NOTIFIER['recipients']
  ExceptionNotifier.sender_address = EXCEPTION_NOTIFIER['sender']
  ExceptionNotifier.email_prefix = EXCEPTION_NOTIFIER['prefix']
EOS

