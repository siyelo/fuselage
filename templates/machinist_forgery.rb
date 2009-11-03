load_sub_template 'machinist'
load_sub_template 'forgery'

file 'spec/blueprints.rb', <<-EOS
require ‘forgery’

# Shams
# We use forgery to make up some test data

Sham.name  { NameForgery.full_name }
Sham.login  { InternetForgery.user_name }
Sham.email  { InternetForgery.email_address }
Sham.password  { BasicForgery.password }
Sham.string { BasicForgery.text }
Sham.text { LoremIpsumForgery.text }

# Blueprints

Role.blueprint do
  name { ‘guest’ }
end

SiteUser.blueprint do
  user_type { ‘SiteUser’ }
  login { Sham.login }
  name { Sham.name }
  email = Sham.email
  email { email }
  email_confirmation { email }
  pwd = Sham.password
  password { pwd }
  password_confirmation { pwd }
  accept_terms { ‘true’ }
  time_zone { ‘Melbourne’ }
end

OpenidUser.blueprint do
  user_type { ‘OpenidUser’ }
  time_zone { ‘Melbourne’ }
  email { Sham.email }
end
EOS