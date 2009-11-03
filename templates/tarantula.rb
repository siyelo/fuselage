
# Standard 'gem' command is not playing nice with gems.github.com - manual 'gem install' works OK though
run 'gem install relevance-tarantula --source http://gems.github.com'

gem_with_version 'relevance-tarantula', :source => 'http://gems.github.com', :env => 'test', :lib => 'relevance/tarantula'

file 'test/tarantula/tarantula_test.rb' do
<<-CODE
require 'test_helper'
require 'relevance/tarantula'

class TarantulaTest < ActionController::IntegrationTest
  # Load enough test data to ensure that there's a link to every page in your
  # application. Doing so allows Tarantula to follow those links and crawl 
  # every page.  For many applications, you can load a decent data set by
  # loading all fixtures.
  fixtures :all

  def test_tarantula
    # If your application requires users to log in before accessing certain 
    # pages, uncomment the lines below and update them to allow this test to
    # log in to your application.  Doing so allows Tarantula to crawl the 
    # pages that are only accessible to logged-in users.
    # 
    #   post '/session', :login => 'quentin', :password => 'monkey'
    #   follow_redirect!
    
    #tarantula_crawl(self)
  end
  
  def test_tarantula_with_tidy
    # If you want to set custom options, you can get access to the crawler 
    # and set properties before running it. For example, this would turn on HTMLTidy.
    #
    # post '/session', :login => 'kilgore', :password => 'trout'
    # assert_response :redirect
    # assert_redirected_to '/'
    # follow_redirect!

    # t = tarantula_crawler(self)
    # t.handlers << Relevance::Tarantula::TidyHandler.new
    # t.crawl '/'
   end
   
  def test_tarantula_sql_injection_and_xss
    # You can specify the attack strings that Tarantula throws at your application.
    # This example adds custom attacks for both SQL injection and XSS. It also tells 
    # Tarantula to crawl the app 2 times. This is important for XSS attacks because 
    # the results won’t appear until the second time Tarantula performs the crawl.
    # t = tarantula_crawler(self)
    # 
    #   Relevance::Tarantula::AttackFormSubmission.attacks << {
    #     :name => :xss,
    #     :input => "<script>gotcha!</script>",
    #     :output => "<script>gotcha!</script>",
    #   }
    # 
    #   Relevance::Tarantula::AttackFormSubmission.attacks << {
    #     :name => :sql_injection,
    #     :input => "a'; DROP TABLE posts;",
    #   }
    # 
    #   t.handlers << Relevance::Tarantula::AttackHandler.new
    #   t.fuzzers << Relevance::Tarantula::AttackFormSubmission
    #   t.times_to_crawl = 2
    #   t.crawl "/posts"
  end
  
  def test_tarantula_with_timeout
    # You can specify a timeout for each specific crawl that Tarantula runs.
    # t = tarantula_crawler(self)
    #  t.times_to_crawl = 2
    #  t.crawl_timeout = 5.minutes
    #  t.crawl "/"
  end
end
CODE
end  

file 'lib/tasks/tarantula.rake', <<-TASK
namespace :tarantula do
  desc 'Run tarantula tests.'
  task :test do
    rm_rf "tmp/tarantula"
    task = Rake::TestTask.new(:tarantula_test) do |t|
      t.libs << 'test'
      t.pattern = 'test/tarantula/**/*_test.rb'
      t.verbose = true
    end

    Rake::Task[:tarantula_test].invoke
  end
  
  desc 'Run tarantula tests and open results in your browser.'
  task :report => :test do
    Dir.glob("tmp/tarantula/**/index.html") do |file|
      if PLATFORM['darwin']
        system("open \#{file}")
      elsif PLATFORM[/linux/]
        system("firefox \#{file}")
      else
        puts "You can view tarantula results at \#{file}"
      end
    end
  end
end
TASK