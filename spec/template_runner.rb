require "active_support"

module Rails
  class TemplateRunner
    attr_reader :root, :files
    attr_writer :logger

    def initialize(template, root = '') # :nodoc:
      @root = File.expand_path(File.directory?(root) ? root : File.join(Dir.pwd, root))
      load_template(template)
    end

    def load_template(template)
      begin
        code = open(template).read
        in_root { self.instance_eval(code) }
      rescue LoadError, Errno::ENOENT => e
        raise "The template [#{template}] could not be loaded. Error: #{e}"
      end
    end

    # Create a new file in the Rails project folder.  Specify the
    # relative path from RAILS_ROOT.  Data is the return value of a block
    # or a data string.
    #
    # ==== Examples
    #
    #   file("lib/fun_party.rb") do
    #     hostname = ask("What is the virtual hostname I should use?")
    #     "vhost.name = #{hostname}"
    #   end
    #
    #   file("config/apach.conf", "your apache config")
    #
    def file(filename, data = nil, log_action = true, &block)
      log 'file', filename if log_action
      @files ||= {}
      @files[filename] = data
    end
    
    # Install a plugin.  You must provide either a Subversion url or Git url.
    # For a Git-hosted plugin, you can specify if it should be added as a submodule instead of cloned.
    #
    # ==== Examples
    #
    #   plugin 'restful-authentication', :git => 'git://github.com/technoweenie/restful-authentication.git'
    #   plugin 'restful-authentication', :git => 'git://github.com/technoweenie/restful-authentication.git', :submodule => true
    #   plugin 'restful-authentication', :svn => 'svn://svnhub.com/technoweenie/restful-authentication/trunk'
    #
    def plugin(name, options)
      log 'plugin', name
    end

    # Adds an entry into config/environment.rb for the supplied gem :
    def gem(name, options = {})
      log 'gem', name
    end
    
    # Adds a line inside the Initializer block for config/environment.rb. Used by #gem
    # If options :env is specified, the line is appended to the corresponding
    # file in config/environments/#{env}.rb
    def environment(data = nil, options = {}, &block)
    end

    # Run a command in git.
    #
    # ==== Examples
    #
    #   git :init
    #   git :add => "this.file that.rb"
    #   git :add => "onefile.rb", :rm => "badfile.cxx"
    #
    def git(command = {})
      if command.is_a?(Symbol)
        log 'running', "git #{command}"
        return run_command(:git, command)
      else
        command.each do |command, options|
          log 'running', "git #{command} #{options}"
          return run_command(:git, "#{command} #{options}")
        end
      end
    end

    # Create a new file in the vendor/ directory. Code can be specified
    # in a block or a data string can be given.
    #
    # ==== Examples
    #
    #   vendor("sekrit.rb") do
    #     sekrit_salt = "#{Time.now}--#{3.years.ago}--#{rand}--"
    #     "salt = '#{sekrit_salt}'"
    #   end
    #
    #   vendor("foreign.rb", "# Foreign code is fun")
    #
    def vendor(filename, data = nil, &block)
      log 'vendoring', filename
    end

    # Create a new file in the lib/ directory. Code can be specified
    # in a block or a data string can be given.
    #
    # ==== Examples
    #
    #   lib("crypto.rb") do
    #     "crypted_special_value = '#{rand}--#{Time.now}--#{rand(1337)}--'"
    #   end
    #
    #   lib("foreign.rb", "# Foreign code is fun")
    #
    def lib(filename, data = nil, &block)
      log 'lib', filename
    end

    # Create a new Rakefile with the provided code (either in a block or a string).
    #
    # ==== Examples
    #
    #   rakefile("bootstrap.rake") do
    #     project = ask("What is the UNIX name of your project?")
    #
    #     <<-TASK
    #       namespace :#{project} do
    #         task :bootstrap do
    #           puts "i like boots!"
    #         end
    #       end
    #     TASK
    #   end
    #
    #   rakefile("seed.rake", "puts 'im plantin ur seedz'")
    #
    def rakefile(filename, data = nil, &block)
      log 'rakefile', filename
    end

    # Create a new initializer with the provided code (either in a block or a string).
    #
    # ==== Examples
    #
    #   initializer("globals.rb") do
    #     data = ""
    #
    #     ['MY_WORK', 'ADMINS', 'BEST_COMPANY_EVAR'].each do
    #       data << "#{const} = :entp"
    #     end
    #
    #     data
    #   end
    #
    #   initializer("api.rb", "API_KEY = '123456'")
    #
    def initializer(filename, data = nil, &block)
      log 'initializer', filename
      file("config/initializers/#{filename}", data || block.call)
    end

    # Generate something using a generator from Rails or a plugin.
    # The second parameter is the argument string that is passed to
    # the generator or an Array that is joined.
    #
    # ==== Example
    #
    #   generate(:authenticated, "user session")
    #
    def generate(what, *args)
      argument = args.map(&:to_s).flatten.join(" ")
      log 'generating', "#{what} #{argument}"
    end

    # Executes a command
    #
    # ==== Example
    #
    #   inside('vendor') do
    #     run('ln -s ~/edge rails)
    #   end
    #
    def run(command, log_action = true)
      log 'executing',  "#{command} from #{Dir.pwd}" if log_action
      run_command(:run, command)
    end

    # Executes a ruby script (taking into account WIN32 platform quirks)
    def run_ruby_script(command, log_action = true)
      ruby_command = RUBY_PLATFORM=~ /win32/ ? 'ruby ' : ''
      run("#{ruby_command}#{command}", log_action)
    end

    # Runs the supplied rake task
    #
    # ==== Example
    #
    #   rake("db:migrate")
    #   rake("db:migrate", :env => "production")
    #   rake("gems:install", :sudo => true)
    #
    def rake(command, options = {})
      log 'rake', command
    end

    # Just run the capify command in root
    #
    # ==== Example
    #
    #   capify!
    #
    def capify!
      log 'capifying'
    end

    # Add Rails to /vendor/rails
    #
    # ==== Example
    #
    #   freeze!
    #
    def freeze!(args = {})
      log 'vendor', 'rails edge'
    end

    # Make an entry in Rails routing file conifg/routes.rb
    #
    # === Example
    #
    #   route "map.root :controller => :welcome"
    #
    def route(routing_code)
      log 'route', routing_code
    end

    def full_log
      @logger.out.rewind
      @logger.out.read
    end
    
    def on_command(command, *args, &block)
      @commands ||= Hash.new { |hash, key| hash[key] = {} }
      @commands[command][args] = block
    end

    def run_command(command, *args)
      if action = @commands[command][args]
        action.call
      end
    end

    protected

    # Get a user's input
    #
    # ==== Example
    #
    #   answer = ask("Should I freeze the latest Rails?")
    #   freeze! if ask("Should I freeze the latest Rails?") == "yes"
    #
    def ask(string)
      log '', string
    end

    # Do something in the root of the Rails application or
    # a provided subfolder; the full path is yielded to the block you provide.
    # The path is set back to the previous path when the method exits.
    def inside(dir = '', &block)
      folder = File.join(root, dir)
      FileUtils.mkdir_p(folder) unless File.exist?(folder)
      FileUtils.cd(folder) { block.arity == 1 ? yield(folder) : yield }
    end

    def in_root
      FileUtils.cd(root) { yield }
    end

    # Helper to test if the user says yes(y)?
    #
    # ==== Example
    #
    #   freeze! if yes?("Should I freeze the latest Rails?")
    #
    def yes?(question)
      answer = ask(question).downcase
      answer == "y" || answer == "yes"
    end

    # Helper to test if the user does NOT say yes(y)?
    #
    # ==== Example
    #
    #   capify! if no?("Will you be using vlad to deploy your application?")
    #
    def no?(question)
      !yes?(question)
    end

    # Run a regular expression replacement on a file
    #
    # ==== Example
    #
    #   gsub_file 'app/controllers/application_controller.rb', /#\s*(filter_parameter_logging :password)/, '\1'
    #
    def gsub_file(relative_destination, regexp, *args, &block)
      log 'gsub_file', relative_destination
      @files ||= {}
      @files[relative_destination] = args.first || block.call
    end

    # Append text to a file
    #
    # ==== Example
    #
    #   append_file 'config/environments/test.rb', 'config.gem "rspec"'
    #
    def append_file(relative_destination, data)
      log 'append_file', relative_destination
      @files ||= {}
      @files[relative_destination] = data
    end

    def destination_path(relative_destination)
      log 'destination_path', relative_destination
    end

    def log(action, message = '')
      logger.log(action, message)
    end

    def logger # quieten the logger; but save to @log_io if needed
      @logger ||= begin
        require 'rails_generator/simple_logger'
        Rails::Generator::SimpleLogger.new(@log_io = StringIO.new)
      end
    end
    
  end
end
