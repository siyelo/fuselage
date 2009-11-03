gem_with_version 'thoughtbot-factory_girl', :lib => 'factory_girl', :source => 'http://gems.github.com', :env => 'test'

inside ('test') do
  run "mkdir factories"
end