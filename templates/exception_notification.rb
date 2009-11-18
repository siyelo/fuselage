#Exception Notifier.
# Note its not much use without the action_mailer.rb template!

plugin 'exception_notifier', :git => 'git://github.com/rails/exception_notification.git'

gsub_file("app/controllers/application_controller.rb", /class ApplicationController < ActionController::Base/mi) do
  "class ApplicationController < ActionController::Base\n  include ExceptionNotifiable"
end

app_name = ENV['_APP']
domain = ENV['_APP_DOMAIN']
recipients = ENV['_APP_EMAILS']
if recipients.nil?
  recipients = ask(" Enter your exception notification recpients (space separated list) : ")
end

file '/config/exception.yml', <<-EOS.gsub(/^  /, '')
  development:
    recipients: #{recipients}
    sender: "Application Error <dev.app.error@#{domain}>"
    prefix: "[#{app_name} Devel] "
  test:
    recipients: #{recipients}
    sender: "Application Error <test.app.error@#{domain}>"
    prefix: "[#{app_name} Test] "
  staging:
    recipients: #{recipients}
    sender: "Application Error <staging.app.error@#{domain}>"
    prefix: "[#{app_name} Staging] "
  production:
    recipients: #{recipients}
    sender: "Application Error <prod.app.error@#{domain}>"
    prefix: "[#{app_name} Prod] "
EOS
  
initializer "exception_notifier.rb", <<-EOS.gsub(/^  /, '')
  env = ENV['RAILS_ENV'] || RAILS_ENV
  EXCEPTION_NOTIFIER = YAML.load_file(RAILS_ROOT + '/config/exception.yml')[env]
  ExceptionNotifier.exception_recipients = EXCEPTION_NOTIFIER['recipients']
  ExceptionNotifier.sender_address = EXCEPTION_NOTIFIER['sender']
  ExceptionNotifier.email_prefix = EXCEPTION_NOTIFIER['prefix']
EOS

