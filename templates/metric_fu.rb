gem_with_version 'jscruggs-metric_fu', :lib => 'metric_fu', :source => 'http://gems.github.com', :env => 'test'

append_file 'Rakefile' , <<-EOS
require 'metric_fu'
EOS

