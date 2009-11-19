
tracker_id = ask('Please enter your google analytics tracker id (or hit enter to do it 
later): ')

tracker_entered?  = tracker_id.nil?

tracker_id = "TODO:TRACKER_ID" if !tracker_entered?

file 'app/views/shared/_google_analytics.html',<<-EOS
<script type="text/javascript">
  var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
  document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
  try {
    var pageTracker = _gat._getTracker("#{tracker_id}");
    pageTracker._trackPageview();
  } catch(err) {}
</script>
EOS

#assumes a HAML file with a 4 space indent i.e. 
#html
#  body
#    <here>
append_file 'app/views/layouts/application.html.haml',
%q{
    #google_analytics_urchin
      = render :partial => "/shared/google_analytics"
}

if !tracker_entered?
  append_file("app/views/layouts/application.html.haml",
%q{
    %h2 Reminder - change the google analytics urchin code in app/views//shared/google_analytics.rb
}
end
