gem_with_version 'recaptcha', :lib => "recaptcha/rails", :source => "http://gems.github.com"

append_file("config/initializers/recaptcha.rb", <<-EOS.gsub(/^    /, ''))
ENV['RECAPTCHA_PUBLIC_KEY'] = 'youractualpublickey'
ENV['RECAPTCHA_PRIVATE_KEY'] = 'youractualprivatekey'
EOS



