
sphinx_binary = run("which searchd").strip

if sphinx_binary.blank?
  puts %q{

  WARN: Thinking-Sphinx requires Sphinx to run. 

  Installation instructions here: http://freelancing-god.github.com/ts/en/installing_sphinx.html

  }
end

gem_with_version 'thinking-sphinx', :source => "http://gemcutter.org"
