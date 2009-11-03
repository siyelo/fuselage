gem_with_version "rspec",       :lib => false, :env => 'test'
gem_with_version "rspec-rails", :lib => 'spec/rails', :env => 'test'

generate "rspec"  

generate 'rspec_controller', 'home index'

# Textmate helper
append_file 'spec/spec_helper.rb', <<-EOS

# When running specs in TextMate, provide an rputs method to cleanly print objects into HTML display
# From http://talklikeaduck.denhaven2.com/2009/09/23/rspec-textmate-pro-tip
module Kernel
  if ENV.keys.find {|env_var| env_var.start_with?("TM_")}
    def rputs(*args)
      puts( *["<pre>", args.collect {|a| CGI.escapeHTML(a.to_s)}, "</pre>"])
    end
  else
    alias_method :rputs, :puts
  end
end
EOS
