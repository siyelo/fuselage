require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "template_runner" do
  before(:each) do
    setup_template_runner "template.rb"
    @runner.on_command(:run, "git config --get github.user") { "github_person\n" }
    @runner.on_command(:run, "which mysqladmin") { "mysqladmin_cmd" }
    @runner.on_command(:run, "which searchd") { "searchd" }
    @runner.run_template
    @log = @runner.full_log
  end

  describe "mysql" do
    it "install okay" do
      @log.should =~ %r{executing  which mysqladmin}
      @log.should =~ %r{executing  cp config/database.yml config/database.yml.example}
      @runner.files['config/database.yml'].should_not be_nil
      @log.should =~ %r{rake db:create RAILS_ENV=development}
      @log.should =~ %r{rake db:create RAILS_ENV=test}
    end
  end
  
  describe "metric_fu" do
    it "install okay" do
      @log.should =~ %r{gem  jscruggs-metric_fu}
      @runner.files['Rakefile'].should =~ /^require 'metric_fu'$/
    end
  end
  
  describe "passenger" do
    it "install okay" do
      @log.should =~ %r{gem  passenger}
    end
  end

  describe "capistrano" do
    it "install okay" do
      @log.should =~ %r{gem  capistrano}
    end
  end 
  
  describe "whenever" do
    it "install okay" do
      @log.should =~ %r{gem  whenever}
    end
  end
  
  describe "exception_notification" do
    it "install okay" do
      @log.should =~ %r{gem  exception_notification}
    end
  end
  
  
  
end
