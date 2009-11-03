@fuselage_dir = File.dirname(__FILE__)

@app_name = "_test_app"

def clean_app
  system "rm -rf ./#{@app_name}"
  system "mysqladmin -uroot drop #{@app_name}_development -f  --password=$MYSQL_PASS"
  system "mysqladmin -uroot drop #{@app_name}_test -f --password=$MYSQL_PASS" 
end

def run_test
  clean = system "cd #{@app_name} && rake db:migrate && rake"
  exit $? unless clean
end

def generate_and_test_app
  clean_app
  system "rails #{@app_name} -m #{@fuselage_dir}/template.rb"
  run_test
end

task :default do
  generate_and_test_app
end