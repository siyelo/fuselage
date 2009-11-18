CURL_TIMEOUT = 5

run "rm -f public/javascripts/*"

run "curl -s -L http://jqueryjs.googlecode.com/files/jquery-1.3.2.min.js --connect-timeout #{CURL_TIMEOUT} > public/javascripts/jquery.js"
run "curl -L http://jqueryjs.googlecode.com/svn/trunk/plugins/form/jquery.form.js --connect-timeout #{CURL_TIMEOUT} > public/javascripts/jquery.form.js"

run "touch public/javascripts/application.js"

#assumes an app HAML file with a 4 space indent i.e. 
#html
#  body
#    <here>
append_file 'app/views/layouts/application.html.haml',
%q{
    #jquery_tag
      = javascript_include_tag 'jquery', 'application', :cache => true
}