plugin 'restful_authentication', :git => 'git://github.com/technoweenie/restful-authentication.git', :submodule => true

# Set up session store initializer
initializer 'session_store.rb', <<-EOS.gsub(/^  /, '')
ActionController::Base.session = { :session_key => '_#{(1..6).map { |x| (65 + rand(26)).chr }.join}_session', :secret => '#{(1..40).map { |x| (65 + rand(26)).chr }.join}' }
ActionController::Base.session_store = :active_record_store
EOS

# Set up sessions
rake 'db:create:all'
rake 'db:sessions:create'

generate 'authenticated', 'user session --include-activation --rspec'

environment("config.active_record.observers = :user_observer")

initializer("mailer.rb", <<-EOS.gsub(/^    /, ''))
mailer_options = YAML.load_file("\#{RAILS_ROOT}/config/mailer.yml")
ActionMailer::Base.smtp_settings = mailer_options
EOS

file("config/mailer.yml", <<-EOS.gsub(/^    /, ''))
:address: mail.authsmtp.com
:domain: #{domain}
:authentication: :login
:user_name: USERNAME
:password: PASSWORD
EOS

append_file("app/views/users/new.html.erb", <<-EOS.gsub(/^    /, ''))
<h2>FIRST - setup activation config/mailer.yml for your mail server</h2>
EOS

gsub_file("app/controllers/application_controller.rb", /class ApplicationController < ActionController::Base/mi) do
  "class ApplicationController < ActionController::Base\n  include AuthenticatedSystem"
end
