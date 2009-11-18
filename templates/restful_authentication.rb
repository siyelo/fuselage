#Restful Auth

#Note: this template should be used in conjunction with the action_mailer template.

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

append_file("app/views/users/new.html.erb", <<-EOS.gsub(/^    /, ''))
<h2>FIRST - setup activation config/mailer.yml for your mail server</h2>
EOS

gsub_file("app/controllers/application_controller.rb", /class ApplicationController < ActionController::Base/mi) do
  "class ApplicationController < ActionController::Base\n  include AuthenticatedSystem"
end
