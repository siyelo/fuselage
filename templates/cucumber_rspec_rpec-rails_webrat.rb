load_sub_template 'rspec'

gem_with_version 'cucumber', :lib => false, :env => 'test'
gem_with_version 'webrat', :lib => false, :env => 'test'

generate 'cucumber'
