puts %q{
  WARN: Note this assumes an *nix style OS installation of MySQL.
   
  The default socket (/var/mysql/mysql.sock) may differ on your system. Create a soft link, or modify config/database.yml accordingly.
  
}

mysql_binary = run("which mysqladmin").strip

if mysql_binary.blank?
  puts %q{ ERROR: You need to configure your MySQL binaries in your PATH
    E.g. on OSX, in your .bash_profile;
    
    export PATH=/opt/local/lib/mysql5/bin/:$PATH

  }
  exit
end

file 'config/database.yml', <<-EOS

development:
  adapter: mysql
  database: #{ENV['_APP_DB']}_development
  username: root
  password: #{ENV['_MYSQL_PASS']}
  host: localhost
  encoding: utf8
  socket: /var/mysql/mysql.sock
    
test:
  adapter: mysql
  database: #{ENV['_APP_DB']}_test
  username: root
  password: #{ENV['_MYSQL_PASS']}
  host: localhost
  encoding: utf8
  socket: /var/mysql/mysql.sock
  
staging:
  adapter: mysql
  database: #{ENV['_APP_DB']}_staging
  username: #{ENV['_APP_DB']}
  password: #{ENV['_MYSQL_PASS']}
  host: localhost
  encoding: utf8
  socket:  /var/mysql/mysql.sock
  
production:
  adapter: mysql
  database: #{ENV['_APP_DB']}_production
  username: #{ENV['_APP_DB']}
  password: #{ENV['_MYSQL_PASS']}
  host: localhost
  encoding: utf8
  socket:  /var/mysql/mysql.sock
EOS

# Copy database.yml for distribution use
run "cp config/database.yml config/database.yml.example"

%w[development test].each do |env|
  run "rake db:create RAILS_ENV=#{env}"
end